{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.10.1";
  sha256 = "1m4inwim5iyahwza3i4zwz4iaja9p93vfacq324r9w8gciyvc26s";
  vendorHash = "sha256-wjICOdn/YqRmWHZQYB/WS0fxJ+OQsnas6BphUC2C9go=";
}
