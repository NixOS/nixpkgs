{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.6.1";
  sha256 = "0lpf9f5bj6x8b21xak6dzwscj0w9jcdvz83fl6nymy8z8y0dybq7";
  vendorHash = "sha256-ePioPHA9gps76VncdPkDEDE3sLUlrCxr7CFsXqoR6KM=";
}
