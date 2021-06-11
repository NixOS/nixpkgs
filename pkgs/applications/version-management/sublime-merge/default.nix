{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2056";
    sha256 = "08472214kazx9fdw7y8gy0bp63mqxcpa79myn2w95wdp0mrlr119";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2055";
    sha256 = "0f5qmxs5cqgdp7gav223ibjwbcrh8bszk1yg1a6hpz8s8j3icvdi";
    dev = true;
  } {};
}
