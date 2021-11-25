{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2063";
    sha256 = "l6vxcOIQ3kQqNzLkf3PbuU3DpDfLh0tXCl/LnJsCt2k=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2055";
    sha256 = "0f5qmxs5cqgdp7gav223ibjwbcrh8bszk1yg1a6hpz8s8j3icvdi";
    dev = true;
  } {};
}
