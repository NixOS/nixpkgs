{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "oldstandard";
  version = "2.2";

  src = fetchzip {
    url = "https://github.com/akryukov/oldstand/releases/download/v${version}/${pname}-${version}.otf.zip";
    stripRoot = false;
    hash = "sha256-cDB5KJm87DK+GczZ3Nmn4l5ejqViswVbwrJ9XbhEh8I=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype *.otf
    install -m444 -Dt $out/share/doc/${pname}-${version}    FONTLOG.txt

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/akryukov/oldstand";
    description = "Attempt to revive a specific type of Modern style of serif typefaces";
    maintainers = with lib.maintainers; [ raskin ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
