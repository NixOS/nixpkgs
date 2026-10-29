{
  stdenvNoCC,
  fetchurl,
  lib,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-wenkai-tc";
  version = "1.530";
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKaiTC/releases/download/v${finalAttrs.version}/lxgw-wenkai-tc-v${finalAttrs.version}.tar.gz";
    hash = "sha256-omCpK9EfTQZvrNpPlGVPWbgCeHTPEKLRaMd5XW00u5k=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/lxgw/LxgwWenKaiTC";
    description = "Traditional Chinese Edition of LXGW WenKai";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lebensterben ];
  };
})
