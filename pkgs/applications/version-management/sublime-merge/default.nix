{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2074";
    sha256 = "REo59Lpi0fmAOp0XJa4Iln3VKxR5kRiMpz2zfqz1MQs=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2070";
    sha256 = "2AA2HBF19g34ov6ytjL2caqS7Ro4eyj18vzwINm0CTw=";
    dev = true;
  } {};
}
