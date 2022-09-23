{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.12.0";
  sha256 = "0p8k5c0gzpmqp7qrhfcjrhbgwd2mzsn2qpsv7ym0ywjkvrkg3355";
  vendorSha256 = "sha256-qjXpzS1ctEQfXFjzyBUiIp6+oqABedpwHqDxQz0DJ8U=";
}
