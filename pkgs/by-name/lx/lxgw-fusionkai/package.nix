{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-fusionkai";
  version = "24.134";

  src = fetchFromGitHub {
    owner = "lxgw";
    repo = "FusionKai";
    rev = "v${version}";
    hash = "sha256-pEISoFEsv8SJOGa2ud/nV1yvl8T9kakfKENu3mfYA5A=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/lxgw/FusionKai";
    description = "Simplified Chinese font derived from LXGW WenKai GB, iansui and Klee One";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ hellodword ];
  };
}
