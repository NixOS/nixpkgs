{
  lib,
  fetchzip,
}:

{
  pysolfc = let
    self = {
      pname = "pysolfc";
      version = "2.21.0";
      src = fetchzip {
        url = "mirror://sourceforge/pysolfc/PySolFC-${self.version}.tar.xz";
        hash = "sha256-Deye7KML5G6RZkth2veVgPOWZI8gnusEvszlrPTAhag=";
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
