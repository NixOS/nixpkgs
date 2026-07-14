{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "smiley-sans";
  version = "2.0.1";

  src = fetchzip {
    url = "https://github.com/atelier-anchor/smiley-sans/releases/download/v${finalAttrs.version}/smiley-sans-v${finalAttrs.version}.zip";
    sha256 = "sha256-p6DwX5MBPemAfV99L9ayLkEWro31ip4tf+wBQr8mkbs=";
    stripRoot = false;
  };

  nativeBuildInputs = [ installFonts ];

  outputs = [
    "out"
    "webfont"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Condensed and oblique Chinese typeface seeking a visual balance between the humanist and the geometric";
    homepage = "https://atelier-anchor.com/typefaces/smiley-sans/";
    changelog = "https://github.com/atelier-anchor/smiley-sans/blob/main/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
})
