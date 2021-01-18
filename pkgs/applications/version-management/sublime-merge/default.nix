{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2039";
    sha256 = "0l82408jli7g6nc267bnnnz0zz015lvpwva5fxj53mval32ii4i8";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2037";
    sha256 = "1s0g18l2msmnn6w7f126andh2dygm9l94fxxhsi64v74mkawqg82";
    dev = true;
  } {};
}
