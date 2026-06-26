{
  stdenvNoCC,
  fetchurl,
  lib,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-wenkai-tc";
  version = "1.522";
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKaiTC/releases/download/v${version}/lxgw-wenkai-tc-v${version}.tar.gz";
    hash = "sha256-E2Z13IOaWwdsAPnHFsYQ2B/d3dhXP4duvdaYO/4PCfg=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/lxgw/LxgwWenKaiTC";
    description = "Traditional Chinese Edition of LXGW WenKai";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lebensterben ];
  };
}
