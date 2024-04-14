{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.4.2";
  sha256 = "0apwhbcnghy7b9kwalbhcgvgcrwv6s55gzlgax55qaa5lxm6r6yz";
  vendorHash = "sha256-bLTummNoDfGMYvtfSLxICgCFZEymPJcRWkQyWOSzKR8=";
}
