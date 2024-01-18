{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.14.8";
  sha256 = "1iag3j3wr3q9sx85rj5nhzs4ygknx2xyazs5kd0vq2l8vb1ihbnn";
  vendorHash = "sha256-bGl8IZppwLDS6cRO4HmflwIOhH3rOhE/9slJATe+onI=";
}
