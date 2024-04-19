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
    buildVersion = "2095";
    dev = true;
    aarch64sha256 = "FmXz8VAWS7e0bB9NeXbihnhdhWMyNJJs6PNt+K2G0Bk=";
    x64sha256 = "83Hw27RgGPgugpf4eMuWT6/MSQ2Q2VBCbaXoSGFtTPI=";
  } { };
}
