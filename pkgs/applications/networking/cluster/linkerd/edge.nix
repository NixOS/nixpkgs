{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.6.3";
  sha256 = "1mlbb8qkx71anwqi027p9lv10kfck811ikfvc5gpnavfaaiwrrd1";
  vendorHash = "sha256-nIDbwUvu1e/1ImVQMj4eOaPeFHM7HCcJMFk/ackdJSE=";
}
