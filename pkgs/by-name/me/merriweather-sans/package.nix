{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "merriweather-sans";
  version = "1.008";

  src = fetchFromGitHub {
    owner = "SorkinType";
    repo = "Merriweather-Sans";
    rev = "8a1b078e3aeec6aecc856c3422898816af9b9dc7";
    sha256 = "1f6a64bv4b4b1v3g2pgrzxcys8rk12wq6wfxamgzligcq5fxaffd";
  };

  # TODO: it would be nice to build this from scratch, but lots of
  # Python dependencies to package (fontmake, gftools)

  # TODO: packaging with python allow update and usage of variable/otf fonts
  nativeBuildInputs = [ installFonts ];

  outputs = [
    "out"
    "webfont"
  ];

  meta = {
    homepage = "https://github.com/SorkinType/Merriweather-Sans";
    description = "Merriweather Sans is a low-contrast semi-condensed sans-serif text typeface family designed to be pleasant to read at very small sizes";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ emily ];
  };
}
