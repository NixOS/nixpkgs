{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "RhodiumLibre";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "DunwichType";
    repo = "RhodiumLibre";
    rev = finalAttrs.version;
    hash = "sha256-YCQvUdjEAj4G71WCRCM0+NwiqRqwt1Ggeg9jb/oWEsY=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "F/OSS/Libre font for Latin and Devanagari";
    homepage = "https://github.com/DunwichType/RhodiumLibre";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
