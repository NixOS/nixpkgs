{
  lib,
  fetchFromGitHub,
  fetchzip,
}:

{
  pysolfc = let
    self = {
      pname = "pysolfc";
      version = "2.21.0";
      src = fetchFromGitHub {
        owner = "shlomif";
        repo = "PysolFC";
        rev = "pysolfc-${self.version}";
        hash = "sha256-2/a78Hbjn/okDyVs8f4rr7cS/nqwfcqDqdzvmggDv3g=";
      };
    };
  in
    self;

  cardsets = let
    self = {
      pname = "pysolfc-cardsets";
      version = "2.2";
      src = fetchzip {
        url = "mirror://sourceforge/pysolfc/PySolFC-Cardsets-${self.version}.tar.bz2";
        hash = "sha256-mWJ0l9rvn9KeZ9rCWy7VjngJzJtSQSmG8zGcYFE4yM0=";
      };
    };
  in
    self;

  music = let
    self = {
      pname = "pysol-music";
      version = "4.50";
      src = fetchzip {
        url = "mirror://sourceforge/pysolfc/pysol-music-${self.version}.tar.xz";
        hash = "sha256-sOl5U98aIorrQHJRy34s0HHaSW8hMUE7q84FMQAj5Yg=";
      };
    };
  in
    self;
}
