{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "public-sans";
  version = "2.001";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://github.com/uswds/public-sans/releases/download/v${finalAttrs.version}/public-sans-v${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-XFs/UMXI/kdrW+53t8Mj26+Rn5p+LQ6KW2K2/ShoIag=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Strong, neutral, principles-driven, open source typeface for text or display";
    homepage = "https://public-sans.digital.gov/";
    changelog = "https://github.com/uswds/public-sans/raw/v${finalAttrs.version}/FONTLOG.txt";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
})
