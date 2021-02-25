{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2039";
    sha256 = "0l82408jli7g6nc267bnnnz0zz015lvpwva5fxj53mval32ii4i8";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2046";
    sha256 = "04laygxr4vm6mawlfmdn2vj0dwj1swab39znsgb1d6rhysz62kjd";
    dev = true;
  } {};
}
