{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "21.10.3";
  sha256 = "09k4c0dgn9vvgp6xb20x0vylk6bbd03srk3sra8vnpywwi591mcv";
  vendorSha256 = "sha256-J/+YFXHC6UTyhln2ZDEq/EyqMEP9XcNC4GRuJjGEY3g=";
}
