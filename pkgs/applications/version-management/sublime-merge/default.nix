{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2074";
    x64sha256 = "REo59Lpi0fmAOp0XJa4Iln3VKxR5kRiMpz2zfqz1MQs=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2076";
    x64sha256 = "k43D+TqS1DImpJKzYuf3LqmsxF3XF9Fwqn2txL13xAA=";
    dev = true;
  } {};
}
