{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.7.1";
  sha256 = "0l4ni88xzh5yylb0m9mn32wiqs3fbiqzz4ll54f9zh72ff89bpjb";
  vendorHash = "sha256-q43WqEBQAtcLikqDwxkMPdVDQOCZ5x7SMmIKsmuDWa4=";
}
