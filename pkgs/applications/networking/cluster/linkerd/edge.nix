{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.10.4";
  sha256 = "1fbzxkfc957kdhk60x3ywwpn54zq8njqk313cgfygnrmmj3m67j9";
  vendorHash = "sha256-WEnopX/tIRoA5wiiCMue1T3wottxv744Mp7XJl63j4k=";
}
