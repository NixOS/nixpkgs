{
  lib,
  stdenv,
  fetchzip,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alice";
  version = "2.003";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://github.com/cyrealtype/Alice/releases/download/v${finalAttrs.version}/Alice-v${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-p+tE3DECfJyBIPyafGZ8jDYQ1lPb+iAnEwLyaUy7DW0=";
  };

  nativeBuildInputs = [ installFonts ];

  dontBuild = true;

  meta = {
    description = "Open-source font by Ksenia Erulevich";
    homepage = "https://github.com/cyrealtype/Alice";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ncfavier ];
  };
})
