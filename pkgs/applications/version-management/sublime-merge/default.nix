{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2047";
    sha256 = "03a0whifhx9py25l96xpqhb4p6hi9qmnrk2bxz6gh02sinsp3mia";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2046";
    sha256 = "04laygxr4vm6mawlfmdn2vj0dwj1swab39znsgb1d6rhysz62kjd";
    dev = true;
  } {};
}
