{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.12.3";
  sha256 = "01vnqhn5lc4pv1rgwmmzzf7ynqc4ss0jysqhjq0m5yzll2k40d8z";
  vendorSha256 = "sha256-7CkeWbgiQIKhuCrJErZrkkx0MD41qxaWAY/18VafLZE=";
}
