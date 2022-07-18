{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2074";
    sha256 = "REo59Lpi0fmAOp0XJa4Iln3VKxR5kRiMpz2zfqz1MQs=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2073";
    sha256 = "AQ0ESdi45LHndRNJnkYS+o9L+dlRJkw3nzBfJo8FYPc=";
    dev = true;
  } {};
}
