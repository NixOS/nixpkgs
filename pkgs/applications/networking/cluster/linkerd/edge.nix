{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.3.3";
  sha256 = "014s1g7v8187ipk5y2azjbrvx6lxhrafkr4k78d7gxpirk50dwhy";
  vendorSha256 = "sha256-kcAtu/YrCgPPamPMEEUUwGBPdiCT9oGQEuYoIq9vGow=";
}
