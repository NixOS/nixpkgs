{
  lib,
  fetchFromGitHub,
  fetchzip,
}:

{
  pysolfc = let
    self = {
      pname = "pysolfc";
      version = "3.0.0";
      src = fetchFromGitHub {
        owner = "shlomif";
        repo = "PysolFC";
        rev = "pysolfc-${self.version}";
        hash = "sha256-i87sx4ir+XWk7RxF9B/R4DoOcZLVN3L1INF4hAnxWyQ=";
      };
    };
  in
    self;

  cardsets = let
    self = {
      pname = "pysolfc-cardsets";
      version = "3.0";
      src = fetchzip {
        url = "mirror://sourceforge/pysolfc/PySolFC-Cardsets-${self.version}.tar.bz2";
        hash = "sha256-UP0dQjoZJg+iSKVOrWbkLj1KCzMWws8ZBVSBLly1a/Y=";
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
