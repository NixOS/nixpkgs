{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.6.2";
  sha256 = "0499zs1iq1a8i2xyg5yb59c8r08nw3zlahbn8w4rsrfb5099924p";
  vendorHash = "sha256-ePioPHA9gps76VncdPkDEDE3sLUlrCxr7CFsXqoR6KM=";
}
