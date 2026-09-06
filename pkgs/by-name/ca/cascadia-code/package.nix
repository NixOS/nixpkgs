{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
  useVariableFont ? false,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cascadia-code";
  version = "2407.24";

  src = fetchzip {
    url = "https://github.com/microsoft/cascadia-code/releases/download/v${finalAttrs.version}/CascadiaCode-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-bCQzGCvjSQ1TXFVC3w9VPXNtjM4h7lRvljVjX/w1TJ4=";
  };

  nativeBuildInputs = [ installFonts ];

  outputs = [
    "out"
    "webfont"
  ];
  rootDir = if useVariableFont then "ttf" else ".";
  excludeFonts = if useVariableFont then [ "static/*" ] else [ "ttf/*.ttf" ];

  meta = {
    description = "Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal";
    homepage = "https://github.com/microsoft/cascadia-code";
    changelog = "https://github.com/microsoft/cascadia-code/raw/v${finalAttrs.version}/FONTLOG.txt";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ ryanccn ];
    platforms = lib.platforms.all;
  };
})
