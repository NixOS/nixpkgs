{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sudo-font";
  version = "3.6";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://github.com/jenskutilek/sudo-font/releases/download/v${finalAttrs.version}/sudo.zip";
    hash = "sha256-4jw1MGxV/a78U7jAfnRLxfZFOqDzyTctCaqKT/s1mMU=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Font for programmers and command line users";
    homepage = "https://www.kutilek.de/sudo-font/";
    changelog = "https://github.com/jenskutilek/sudo-font/raw/v${finalAttrs.version}/sudo/FONTLOG.txt";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
})
