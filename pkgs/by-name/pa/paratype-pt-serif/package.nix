{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "paratype-pt-serif";
  version = "1.000";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "a4f3deeca2d7547351ff746f7bf3b51f5528dbcf";
    hash = "sha256-HpA4r5VqAVtPFY9ltRUeZERNfyFRkAvwununoDF+5mk=";
    rootDir = "ofl/ptserif";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.paratype.ru/catalog/font/pt/pt-serif";
    description = "Open Paratype font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      raskin
      pancaek
    ];
  };
}
