/**
 * Let's make amoebas!
 */
 
import de.voidplus.leapmotion.*;

int screenWidth = 800;
int screenHeight = 600;
PVector center = new PVector(screenWidth/2, screenHeight/2);

LeapMotion leap;

void setup() {
  size(screenWidth, screenHeight);
  background(0);
  
  leap = new LeapMotion(this);
}

void draw() {
  fill(0);
  rect(0, 0, screenWidth, screenHeight);
  
  ArrayList<PVector> points = new ArrayList<PVector>();
  ArrayList<PVector> inners = new ArrayList<PVector>();
  ArrayList<PVector> coords = new ArrayList<PVector>();
  int[] quadrantFill = {0, 0, 0, 0};
  
  points.add(new PVector(screenWidth/2 - 100, screenHeight/2 - 100));
  points.add(new PVector(screenWidth/2, screenHeight/2 - 150));
  points.add(new PVector(screenWidth/2 + 100, screenHeight/2 - 100));
  points.add(new PVector(screenWidth/2 + 100, screenHeight/2 + 100));
  points.add(new PVector(screenWidth/2 - 100, screenHeight/2 + 100));
  
  PVector position = new PVector();
  try {
    for(Hand hand : leap.getHands()){
      for(Finger finger : hand.getFingers()){
        position = finger.getPosition();
        int i = 0;
        float angle = angle(position, center);
        if(-degrees(angle) < -90) {
          quadrantFill[2]++;
        } else if(-degrees(angle) < 0) {
          quadrantFill[3]++;
        } else if(-degrees(angle) < 90) {
          quadrantFill[0]++;
        } else {
          quadrantFill[1]++;
        }
        while(i < points.size() && (angle > angle(points.get(i), center))) {
          i++;
        }
        points.add(i, position);
      }
    }
  } catch(NullPointerException e){
    System.out.print(e);
  }
  
  
  for(int i = 0; i < quadrantFill.length; i++) {
        System.out.print(quadrantFill[i]);
        System.out.print(", ");
  }
  
  for(int i = 0; i < points.size(); i++) {
    inners.add(midpoint(center, midpoint(points.get(i), points.get((i+1)%points.size()))));
  }

  for(int i = 0; i < points.size(); i++) {
    coords.add(points.get(i));
    coords.add(inners.get(i));
  }
    System.out.println();
  
  int i;
  
  smooth();

  // draw the amoeba!
  if(coords.size() >= 3) {
    noStroke();
    fill(20*(quadrantFill[2] + quadrantFill[3]) + 55, 20*(quadrantFill[0] + quadrantFill[1]) + 55, 0);
    beginShape();
    PVector inner;
    for(i = 0; i < coords.size(); i++) {
      curveVertex(coords.get(i).x, coords.get(i).y);
    }
    for(i = 0; i < 3; i++) {
      curveVertex(coords.get(i).x, coords.get(i).y);
    }
    endShape();
  }
  
  fill(0);
  ellipse(screenWidth/2 + 25, screenHeight/2, (quadrantFill[2] + quadrantFill[3])*2 + 10, (quadrantFill[0] + quadrantFill[1])*2 + 10);
  ellipse(screenWidth/2 - 25, screenHeight/2, (quadrantFill[2] + quadrantFill[3])*2 + 10, (quadrantFill[0] + quadrantFill[1])*2 + 10);
}

PVector midpoint(PVector a, PVector b) {
  return PVector.div(PVector.add(a, b), 2);
}

float angle(PVector a, PVector b) {
  return atan2(a.y - b.y, a.x - b.x);
}
