{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.7.2";
  sha256 = "068qvj8fyxyd8i0qgip28sqdd571kh59jijc8bdml3r6mr5ilp79";
  vendorHash = "sha256-wM/45cd5t9Q6BgosfMRaKjVKuGoZ5Zv3y5D7pBFXoCM=";
}
