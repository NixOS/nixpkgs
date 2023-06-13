{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.13.4";
  sha256 = "094i9a5l5nmygja1q73ipi01m6w1jsnr6l04g5629na72568zh6w";
  vendorSha256 = "sha256-5T3YrYr7xeRkAADeE24BPu4PYU4mHFspqAiBpS8n4Y0=";
}
