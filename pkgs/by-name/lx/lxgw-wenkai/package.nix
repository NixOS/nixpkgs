{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-wenkai";
  version = "1.521";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai/releases/download/v${version}/lxgw-wenkai-v${version}.tar.gz";
    hash = "sha256-4GWCSMl+gdxnEPa8JPz7c+bWmxP7HaZHj+D0yUDqgVc=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://lxgw.github.io/";
    description = "Open-source Chinese font derived from Fontworks' Klee One";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ryanccn ];
  };
}
