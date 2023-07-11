{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2083";
    x64sha256 = "bWHbP8j228jUDr1XDLRciq7hcET6o6Udr/lLODXRudc=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2085";
    x64sha256 = "40yI6EtP2l22aPP50an3ycvdEcAqJphhGhYYoOPyHw0=";
    dev = true;
  } {};
}
