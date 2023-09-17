{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2091";
    x64sha256 = "T5g6gHgl9xGytEOsh3VuB08IrbDvMu24o/1edCGmfd4=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2085";
    x64sha256 = "40yI6EtP2l22aPP50an3ycvdEcAqJphhGhYYoOPyHw0=";
    dev = true;
  } {};
}
