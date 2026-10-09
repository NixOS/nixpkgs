{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "koruri";
  version = "20210720";

  src = fetchFromGitHub {
    owner = "Koruri";
    repo = "Koruri";
    tag = finalAttrs.version;
    hash = "sha256-zL9UtT15mWvsXgGJqbTs6cOsQaoh/0AIAyQ5z7JpTXk=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Japanese TrueType font obtained by mixing M+ FONTS and Open Sans";
    homepage = "https://github.com/Koruri/Koruri";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ haruki7049 ];
    platforms = lib.platforms.all;
  };
})
