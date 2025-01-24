{ fetchFromGitHub }:

{
  qmplay2 =
    let
      self = {
        pname = "qmplay2";
        version = "24.06.16";

        src = fetchFromGitHub {
          owner = "zaps166";
          repo = "QMPlay2";
          rev = self.version;
          hash = "sha256-HoFyC/OFmthUYfyo6//+KmBIq06MPb5GmDekJbnsz5o=";
        };
      };
    in
    self;

  qmvk = {
    pname = "qmvk";
    version = "0-unstable-2024-04-19";

    src = fetchFromGitHub {
      owner = "zaps166";
      repo = "QmVk";
      rev = "5c5c2942255820b6343afdfeea0405cd3b36870e";
      hash = "sha256-viFM9N5PiSCgkGlxtrLFCVDIML/QyPiaPRX77RW2NNw=";
    };
  };
}
