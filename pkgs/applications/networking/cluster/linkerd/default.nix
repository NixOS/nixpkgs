{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.13.5";
  sha256 = "0mjb0wcwyd51ap0kvkfmykh6zqijg4z2g5yxvp9aq67l984wh7sb";
  vendorSha256 = "sha256-5T3YrYr7xeRkAADeE24BPu4PYU4mHFspqAiBpS8n4Y0=";
}
