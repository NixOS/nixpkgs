{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "komikandy";
  version = "0-unstable-2001-05-12";

  src = fetchzip {
    url = "https://www.1001fonts.com/download/komikandy.zip";
    hash = "sha256-NqpR+gM2giTHGUBYoJlO8vkzOD0ep7LzAry3nIagjLY=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 *.ttf -t $out/share/fonts/ttf
    runHook postInstall
  '';

  meta = {
    homepage = "https://pedroreina.net/apostrophiclab/0122-Komikandy/komikandy.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
