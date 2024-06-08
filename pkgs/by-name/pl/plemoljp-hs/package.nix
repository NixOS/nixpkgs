{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "plemoljp-hs";
  version = "1.7.1";

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${version}/PlemolJP_HS_v${version}.zip";
    hash = "sha256-JbuKBU1TT0qE89N61jX+WF25PBRHo/RSAtdPa5Ni8og=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 PlemolJP_HS/*.ttf -t $out/share/fonts/truetype/${pname}
    install -Dm444 PlemolJP35_HS/*.ttf -t $out/share/fonts/truetype/${pname}-35
    install -Dm444 PlemolJPConsole_HS/*.ttf -t $out/share/fonts/truetype/${pname}-console
    install -Dm444 PlemolJP35Console_HS/*.ttf -t $out/share/fonts/truetype/${pname}-35console

    runHook postInstall
  '';

  meta = with lib; {
    description = "A composite font of IBM Plex Mono, IBM Plex Sans JP and hidden full-width space";
    homepage = "https://github.com/yuru7/PlemolJP";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ kachick ];
  };
}
