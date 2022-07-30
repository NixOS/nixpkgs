{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2074";
    hashes = {
      "x86_64-linux" = "REo59Lpi0fmAOp0XJa4Iln3VKxR5kRiMpz2zfqz1MQs=";
      "aarch64-linux" = "04f1hcqk6mlwi59p16ndqdk459w2kpfl5qz60jqzyg4bw65h342d";
    };
  } {};

  sublime-merge-dev = common {
    buildVersion = "2073";
    hashes = {
      "x86_64-linux" = "AQ0ESdi45LHndRNJnkYS+o9L+dlRJkw3nzBfJo8FYPc=";
      "aarch64-linux" = "02k9z6hjvj4q5hp96ypbpil8psl4lig8wa9nwbci8710v2hk5g4y";
    };
    dev = true;
  } {};
}
