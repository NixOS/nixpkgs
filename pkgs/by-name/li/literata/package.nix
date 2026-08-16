{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "literata";
  version = "3.103";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://github.com/googlefonts/literata/releases/download/${finalAttrs.version}/${finalAttrs.version}.zip";
    hash = "sha256-XwwvyzwO2uhi1Bay9HtB75j1QfAJR4TMETgy/zyvwZ0=";
    stripRoot = false;
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Serif typeface designed for ebooks and optimized for reading";
    homepage = "https://github.com/googlefonts/literata";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ xavwe ];
    platforms = lib.platforms.all;
  };
})
