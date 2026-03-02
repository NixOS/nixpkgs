{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "komikazba";
  version = "0-unstable-2000-10-30";

  src = fetchzip {
    url = "https://www.1001fonts.com/download/komikazba.zip";
    hash = "sha256-SGJMP0OdZ/AEImN5S3QshCbWSLXO4qTjHnSQYqoy3Pc=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 *.ttf -t $out/share/fonts/ttf
    runHook postInstall
  '';

  meta = {
    homepage = "https://pedroreina.net/apostrophiclab/0052-Komikazba/komikazba.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
