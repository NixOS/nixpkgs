{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sn-pro";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "supernotes";
    repo = "sn-pro";
    tag = finalAttrs.version;
    hash = "sha256-H8YG7FMn03tiBxz5TZDzowicqtewfX6rYd03pdTPYSo=";
  };

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "SN Pro Font Family";
    homepage = "https://github.com/supernotes/sn-pro";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
})
