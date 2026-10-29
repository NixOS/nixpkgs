{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-wenkai";
  version = "1.530";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai/releases/download/v${finalAttrs.version}/lxgw-wenkai-v${finalAttrs.version}.tar.gz";
    hash = "sha256-ojw3MPIaP+kYgc0oLrFdzeraF8ZXGNvGmw0mHKfB4QM=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://lxgw.github.io/";
    description = "Open-source Chinese font derived from Fontworks' Klee One";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ryanccn ];
  };
})
