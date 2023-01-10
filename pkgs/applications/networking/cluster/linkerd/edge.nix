{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "22.12.1";
  sha256 = "1ss6rhh71nq89ya8312fgy30pdw9vvnvnc8a7zs8a8yqg6p4x9lp";
  vendorSha256 = "sha256-V4BQ+7J1T+g5I7SrCexkfe3ngl7Qy3cf0SF+u28QKWE=";
}
