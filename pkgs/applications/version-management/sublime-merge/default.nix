{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2091";
    aarch64sha256 = "dkPKuuzQQtL3eZlaAPeL7e2p5PCxroFRSp6Rw5wHODc=";
    x64sha256 = "T5g6gHgl9xGytEOsh3VuB08IrbDvMu24o/1edCGmfd4=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2094";
    dev = true;
    aarch64sha256 = "ZJgq971EPzq+BWxTQAoX6TgUmTfpf9sI4CHPcvgPTfI=";
    x64sha256 = "6FLfszhP+BGHX5FrycMlznREmGDLyDyo6rgmqxhtCak=";
  } { };
}
