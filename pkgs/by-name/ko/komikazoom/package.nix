{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "komikazoom";
  version = "0-unstable-2000-09-29";

  src = fetchzip {
    url = "https://www.1001fonts.com/download/komikazoom.zip";
    hash = "sha256-/o2QPPPiQBkNU0XRxJyI0+5CKFEv4FKU3A5ku1zyVX4=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 *.ttf -t $out/share/fonts/ttf
    runHook postInstall
  '';

  meta = {
    homepage = "https://pedroreina.net/apostrophiclab/0046-Komikazoom/komikazoom.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
