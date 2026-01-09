{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.14.9";
  sha256 = "135x5q0a8knckbjkag2xqcr76zy49i57zf2hlsa70iknynq33ys7";
  vendorHash = "sha256-bGl8IZppwLDS6cRO4HmflwIOhH3rOhE/9slJATe+onI=";
}
