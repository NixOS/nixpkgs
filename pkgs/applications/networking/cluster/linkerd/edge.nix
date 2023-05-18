{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.4.3";
  sha256 = "1wyqqb2frxrid7ln0qq8x6y3sg0a6dnq464csryzsh00arycyfph";
  vendorSha256 = "sha256-5T3YrYr7xeRkAADeE24BPu4PYU4mHFspqAiBpS8n4Y0=";
}
