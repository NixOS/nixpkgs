{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "komikaze";
  version = "0-unstable-2000-09-23";

  src = fetchzip {
    url = "https://www.1001fonts.com/download/komikaze.zip";
    hash = "sha256-daJRwgkzL5v224KwkaGMK2FqVnfin8+8WvMTvXTkCGE=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 *.ttf -t $out/share/fonts/ttf
    runHook postInstall
  '';

  meta = {
    homepage = "https://pedroreina.net/apostrophiclab/0045-Komikaze/komikaze.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
