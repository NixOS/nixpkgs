{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "21.10.3";
  sha256 = "09k4c0dgn9vvgp6xb20x0vylk6bbd03srk3sra8vnpywwi591mcv";
  vendorSha256 = "sha256-uGj1sMEa791ZKA7hpJ1A9vtwsmrZDGAYp6HQo6QNAYY=";
}
