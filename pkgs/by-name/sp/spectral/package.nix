{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "spectral";
  version = "2.005";

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "productiontype";
    repo = "Spectral";
    rev = "e1179c4fc05c1ba7efd40038e203312b4c90c376";
    hash = "sha256-hoihZUeY8JC0pCnLfTwBAoX1OiTKyG/4B4XeXyc3iVg=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/productiontype/Spectral/";
    description = "Serif typeface designed for text-rich, screen-first environments";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ozozka ];
  };
}
