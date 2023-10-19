{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2091";
    aarch64sha256 = "dkPKuuzQQtL3eZlaAPeL7e2p5PCxroFRSp6Rw5wHODc=";
    x64sha256 = "T5g6gHgl9xGytEOsh3VuB08IrbDvMu24o/1edCGmfd4=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2090";
    aarch64sha256 = "96nJn+7bVoLM6D14pFujlj3JOQL5PwdU1+SWzEjoYhU=";
    x64sha256 = "bu51gsu0XxZBF8/HncPttcKiIRpC7qsKTgR9cktKOnI=";
    dev = true;
  } {};
}
