{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.13.3";
  sha256 = "080ay0qqb98m208rzj3jnv4jprcfg60b46dbv594i9ps6vhb4ndc";
  vendorSha256 = "sha256-5T3YrYr7xeRkAADeE24BPu4PYU4mHFspqAiBpS8n4Y0=";
}
