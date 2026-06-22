{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ccsymbols";
  version = "2020-04-19";

  src = fetchurl {
    url = "https://www.ctrl.blog/file/${finalAttrs.version}_cc-symbols.zip";
    hash = "sha256-hkARhb8T6VgGAybYkVuPuebjhuk1dwiBJ1bZMwvYpMY=";
  };

  sourceRoot = ".";

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [
    installFonts
    unzip
  ];

  passthru = { inherit (finalAttrs) pname version; };

  meta = {
    description = "Creative Commons symbol font";
    homepage = "https://www.ctrl.blog/entry/creative-commons-unicode-fallback-font.html";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
  };
})
