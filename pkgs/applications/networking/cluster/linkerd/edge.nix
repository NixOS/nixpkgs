{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.2.1";
  sha256 = "0l5kmspvr0ddagrm9bmbl4hqgr9k3n3xb9fr6fcf8fs8f75r27k6";
  vendorHash = "sha256-zkHyP5muVN7002/XoW8adWNswj9diixE1E1zRGQe0ms=";
}
