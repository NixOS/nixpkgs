{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.4.4";
  sha256 = "07p4cgl4myv7kv9pxvxrvsqnl3vkd9ay5hngx5g6xds2sc8va306";
  vendorHash = "sha256-bLTummNoDfGMYvtfSLxICgCFZEymPJcRWkQyWOSzKR8=";
}
