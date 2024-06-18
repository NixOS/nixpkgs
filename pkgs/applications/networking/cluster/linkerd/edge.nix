{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.6.2";
  sha256 = "0qghp8v4lz51yv5j5k8dps4qv58hjdjdc3jzrrq3g239x8b2h6ys";
  vendorHash = "sha256-7Q6V9DKROkSTxU7n511aOpaMDRfhP88p6PJ89Sr6kOQ=";
}
