{
  fetchFromGitHub,
}:

{
  qmplay2 = let
    self = {
      pname = "qmplay2";
      version = "24.04.07";

      src = fetchFromGitHub {
        owner = "zaps166";
        repo = "QMPlay2";
        rev = self.version;
        fetchSubmodules = true;
        hash = "sha256-WIDGApvl+aaB3Vdv0sHY+FHWqzreWWd3/xOLV11YfxM=";
      };
    };
  in
    self;
}
