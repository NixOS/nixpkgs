{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2047";
    sha256 = "03a0whifhx9py25l96xpqhb4p6hi9qmnrk2bxz6gh02sinsp3mia";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2055";
    sha256 = "0f5qmxs5cqgdp7gav223ibjwbcrh8bszk1yg1a6hpz8s8j3icvdi";
    dev = true;
  } {};
}
