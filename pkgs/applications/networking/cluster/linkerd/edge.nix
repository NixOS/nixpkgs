{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.3.4";
  sha256 = "19i0g1vbfyjc2nlqh1iml0siqb3zi91ky8lf83ng40r49p1b1c6h";
  vendorSha256 = "sha256-f77s+WzLhHGbFdJfNRuhdx/DLFB/JyD5hG8ApCZ+h/s=";
}
