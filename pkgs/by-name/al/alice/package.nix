{
  lib,
  stdenv,
  fetchzip,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "Alice";
  version = "2.003";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url =
      with finalAttrs;
      "https://github.com/cyrealtype/${pname}/releases/download/v${version}/${pname}-v${version}.zip";
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
