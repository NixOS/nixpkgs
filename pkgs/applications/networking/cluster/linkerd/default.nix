{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.14.6";
  sha256 = "0q0c2gd7d7ws4v4lqql6l3l68g5kjypfmcc0vwyy0xx68z8sxm75";
  vendorHash = "sha256-bGl8IZppwLDS6cRO4HmflwIOhH3rOhE/9slJATe+onI=";
}
