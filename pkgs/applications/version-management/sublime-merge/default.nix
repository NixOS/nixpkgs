{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "1107";
    sha256 = "70edbb16529d638ea41a694dbc5b1408c76fcc3a7d663ef0e48b4e89e1f19c71";
  } {};

  sublime-merge-dev = common {
    buildVersion = "1111";
    sha256 = "d287b77b36febe52623db4546bef978dceb0654257b9a70c798d9cd394305c0d";
    dev = true;
  } {};
}
