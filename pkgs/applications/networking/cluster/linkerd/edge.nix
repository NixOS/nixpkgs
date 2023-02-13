{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.2.1";
  sha256 = "0qjl6qxfg6bj22fwm2y01if5dqp2w79y45ibrg46r33pf6gbwjxj";
  vendorSha256 = "sha256-YxWBjbE3aBFfCbQeSTfQv5QzP5n4IRHHqNrFwrJPQ7g=";
}
