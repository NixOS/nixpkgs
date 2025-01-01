{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "plemoljp-hs";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${version}/PlemolJP_HS_v${version}.zip";
    hash = "sha256-0p1orGKMKYiIZymAtbHp87DoS89ir9SbYfhs1Ki1JbE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 PlemolJP_HS/*.ttf -t $out/share/fonts/truetype/plemoljp-hs
    install -Dm444 PlemolJP35_HS/*.ttf -t $out/share/fonts/truetype/plemoljp-hs-35
    install -Dm444 PlemolJPConsole_HS/*.ttf -t $out/share/fonts/truetype/plemoljp-hs-console
    install -Dm444 PlemolJP35Console_HS/*.ttf -t $out/share/fonts/truetype/plemoljp-hs-35console

    runHook postInstall
  '';

  meta = with lib; {
    description = "Composite font of IBM Plex Mono, IBM Plex Sans JP and hidden full-width space";
    homepage = "https://github.com/yuru7/PlemolJP";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ kachick ];
  };
}
