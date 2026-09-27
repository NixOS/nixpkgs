{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "merriweather";
  version = "2.200";

  src = fetchFromGitHub {
    owner = "SorkinType";
    repo = "Merriweather";
    rev = "6e3263d6241aeb747ebfcdd4af3ff8bd1013bb49";
    sha256 = "sha256-mpVJpxI98VxHpZMFFyTHjxTPcUTB1kK8XCGa32znMcQ=";
  };

  # TODO: it would be nice to build this from scratch, but lots of
  # Python dependencies to package (fontmake, gftools)

  nativeBuildInputs = [ installFonts ];

  outputs = [
    "out"
    "webfont"
  ];

  meta = {
    homepage = "https://github.com/SorkinType/Merriweather";
    description = "Text face designed to be pleasant to read on screens";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ emily ];
  };
})
