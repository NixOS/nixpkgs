{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "roboto-serif";
  version = "1.008";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchurl {
    url = "https://github.com/googlefonts/roboto-serif/releases/download/v${finalAttrs.version}/RobotoSerifFonts-v${finalAttrs.version}.zip";
    hash = "sha256-Nm9DcxL0CgA51nGeZJPWSCipgqwnNPlhj0wHyGhLaYQ=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    installFonts
  ];

  meta = {
    description = "Roboto family of fonts";
    longDescription = ''
      Google’s signature family of fonts, the default font on Android and
      Chrome OS, and the recommended font for Google’s visual language,
      Material Design.
    '';
    homepage = "https://github.com/googlefonts/roboto-serif";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.all;
  };
})
