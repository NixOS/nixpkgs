{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.5.1";
  sha256 = "0wnj2v08j71aq8p3qx3k71xkbnr84vxgd3cidka7lxrj21hcbk0q";
  vendorHash = "sha256-dxTTxTwDWvcDJiwMtqg814oUx0TsUcon7Wx0sVIq26A=";
}
