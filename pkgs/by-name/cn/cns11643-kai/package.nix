{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "cns11643-kai";
  version = "0-unstable-2024-09-13";

  src = fetchzip {
    url = "https://www.cns11643.gov.tw/opendata/Fonts_Kai.zip";
    hash = "sha256-zKFzqCbf41hbg3G6ShGJTsA8YgsTbw3SHEETn476LZA=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = {
    description = "Chinese TrueType Kai font by Ministry of Education of Taiwan government";
    homepage = "https://www.cns11643.gov.tw/";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.rypervenche ];
    platforms = lib.platforms.all;
  };
}
