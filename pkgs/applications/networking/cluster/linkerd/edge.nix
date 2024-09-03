{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.8.2";
  sha256 = "0jvyw002xy5zdb27q02r3bj88138zpc73an61sbgmls3jwp9w9iq";
  vendorHash = "sha256-16tdpREYDJDvwIZLpwCxGsZGERxMdSyPH7c6wbD2GCI=";
}
