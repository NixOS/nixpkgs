{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.5.3";
  sha256 = "0dwbaqd4k8yx8n2aqvg7l1ydjqbdxv0n0wnm1bsi7cxj7yn5kzp5";
  vendorHash = "sha256-tXe1dQMKb96SDU4gn9hyVEl2vI1ISaffzCy1gHd1unM=";
}
