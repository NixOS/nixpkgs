{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2091";
    x64sha256 = "T5g6gHgl9xGytEOsh3VuB08IrbDvMu24o/1edCGmfd4=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2090";
    x64sha256 = "bu51gsu0XxZBF8/HncPttcKiIRpC7qsKTgR9cktKOnI=";
    dev = true;
  } {};
}
