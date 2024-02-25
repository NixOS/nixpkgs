{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.2.3";
  sha256 = "0l1sa8xzqddvyzlzddcb9nbvxlj06dm5l6fb0f6fw9ay0d8qm22k";
  vendorHash = "sha256-g1e1uY43fUC2srKK9erVFlJDSwWrEvq4ni0PgeCFaOg=";
}
