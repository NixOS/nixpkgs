{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "plemoljp";
  version = "2.0.3";

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${version}/PlemolJP_v${version}.zip";
    hash = "sha256-cT2BpD2PoAd38uYCQlq5fv9NYgwInblrYdK/XDEmOWI=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 PlemolJP/*.ttf -t $out/share/fonts/truetype/plemoljp
    install -Dm444 PlemolJP35/*.ttf -t $out/share/fonts/truetype/plemoljp-35
    install -Dm444 PlemolJPConsole/*.ttf -t $out/share/fonts/truetype/plemoljp-console
    install -Dm444 PlemolJP35Console/*.ttf -t $out/share/fonts/truetype/plemoljp-35console

    runHook postInstall
  '';

  meta = with lib; {
    description = "Composite font of IBM Plex Mono and IBM Plex Sans JP";
    homepage = "https://github.com/yuru7/PlemolJP";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ kachick ];
  };
}
