{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sudo-font";
  version = "3.4";

  src = fetchzip {
    url = "https://github.com/jenskutilek/sudo-font/releases/download/v${version}/sudo.zip";
    hash = "sha256-sSLY94wY9+AYAqWDq+Xy+KctUfJVS0jeS3baF8mLO9I=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = {
    description = "Font for programmers and command line users";
    homepage = "https://www.kutilek.de/sudo-font/";
    changelog = "https://github.com/jenskutilek/sudo-font/raw/v${version}/sudo/FONTLOG.txt";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
