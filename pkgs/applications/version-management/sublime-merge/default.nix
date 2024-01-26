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
    buildVersion = "2092";
    aarch64sha256 = "3QMDynXMVB4QVtM8EPbZ8I4m+5sEjzs8XN+jEoMaktM=";
    x64sha256 = "S9E+wRvO41Eq+PLA/J+sjBIAn6yz715Wg9bKRW2Eobg=";
    dev = true;
  } {};
}
