{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.8.2";
  sha256 = "18lz817d1jjl8ynkdhvm32p8ja9bkh1xqkpi514cws27y3zcirrz";
  vendorSha256 = "sha256-SIyS01EGpb3yzw3NIBAO47ixAiWPX2F+9ANoeCTkbRg=";
}
