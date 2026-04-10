{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sudo-font";
  version = "3.4";

  src = fetchzip {
    url = "https://github.com/jenskutilek/sudo-font/releases/download/v${finalAttrs.version}/sudo.zip";
    hash = "sha256-sSLY94wY9+AYAqWDq+Xy+KctUfJVS0jeS3baF8mLO9I=";
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
