{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "behdad-fonts";
  version = "0.0.3";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "font-store";
    repo = "BehdadFont";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gKfzxo3/bCMKXl2d6SP07ahIiNrUyrk/SN5XLND2lWY=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/font-store/BehdadFont";
    description = "Persian/Arabic Open Source Font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pancaek ];
  };
})
