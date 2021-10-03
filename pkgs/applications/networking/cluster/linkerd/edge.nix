{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "21.9.3";
  sha256 = "0swqx4myvr24visj39icg8g90kj325pvf22bq447rnm0whq3cnyz";
  vendorSha256 = "sha256-fMtAR66TwMNR/HCVQ9Jg3sJ0XBx2jUKDG7/ts0lEZM4=";
}
