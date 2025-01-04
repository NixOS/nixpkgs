{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sudo-font";
  version = "2.1";

  src = fetchzip {
    url = "https://github.com/jenskutilek/sudo-font/releases/download/v${version}/sudo.zip";
    hash = "sha256-ER+TpODf+Inqo+XWJRNOHumzGRL4Dms5N1E+BU7Tr94=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Font for programmers and command line users";
    homepage = "https://www.kutilek.de/sudo-font/";
    changelog = "https://github.com/jenskutilek/sudo-font/raw/v${version}/sudo/FONTLOG.txt";
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
