{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4169";
      x64sha256 = "jk9wKC0QgfhiHDYUcnDhsmgJsBPOUmCkyvQeI54IJJ4=";
      aarch64sha256 = "/W/xGbE+8gGu1zNh6lERZrfG9Dh9QUGkYiqTzp216JI=";
    } {};

    sublime4-dev = common {
      buildVersion = "4168";
      dev = true;
      x64sha256 = "KfW1Mh78CUBTmthHQd1s15a7GrmssSnWZ1RgaarJeag=";
      aarch64sha256 = "qJ9oix1kwWN+TUb5/WSKyHcHzB+Q87XolMOhmqx1OFc=";
    } {};
  }
