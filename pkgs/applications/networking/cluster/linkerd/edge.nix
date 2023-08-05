{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.7.2";
  sha256 = "0wc829dzk0in0srq0vbcagrd5ylz2d758032anzlzkf4m3lr9hdw";
  vendorSha256 = "sha256-16j5B96UDZITY1LEWZKtfAnww7ZcUjKh/cARLaYy9wk=";
}
