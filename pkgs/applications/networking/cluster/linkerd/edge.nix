{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.8.1";
  sha256 = "0ajcxfqbaimrj8ylbk3s2djv2jpczm4c6z39b4fdak68sylmvb9z";
  vendorSha256 = "sha256-sj3KJLPO4pxnGov2Oiqj1FgAQ2atf3FJPINmeKjPUZQ=";
}
