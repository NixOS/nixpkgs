{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.4.1";
  sha256 = "18hv0lfh1ldy7chjs2ssn62crn71a0mvvn1g8b35l91g8mqyh4ry";
  vendorHash = "sha256-vKehadl94okOd1YfaETgdQwWr8F2gOPGyjzzTjxKyLA=";
}
