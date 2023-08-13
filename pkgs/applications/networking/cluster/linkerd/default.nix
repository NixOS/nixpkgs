{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.13.6";
  sha256 = "1z5gcz1liyxydy227vb350k0hsq31x80kvxamx7l1xkd2p0mcmbj";
  vendorSha256 = "sha256-5T3YrYr7xeRkAADeE24BPu4PYU4mHFspqAiBpS8n4Y0=";
}
