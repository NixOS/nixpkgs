{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "komikahuna";
  version = "0-unstable-2000-10-14";

  src = fetchzip {
    url = "https://www.1001fonts.com/download/komikahuna.zip";
    hash = "sha256-TjGxQA3ZyIOyJUNP+MVkYiSDk9WDIDPy3d2ttWC1aoc=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 *.ttf -t $out/share/fonts/ttf
    runHook postInstall
  '';

  meta = {
    homepage = "https://pedroreina.net/apostrophiclab/0049-Komikahuna/komikahuna.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
