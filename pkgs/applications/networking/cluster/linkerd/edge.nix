{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.10.3";
  sha256 = "1xsimk3kjniy59sw56q52cmnpg1vb1l1zbaj6nrj44pl57vkp9cp";
  vendorHash = "sha256-JVXhZjUdU1CrWzrh7INhAd3kRP/tcdsYzlre9SB9gOQ=";
}
