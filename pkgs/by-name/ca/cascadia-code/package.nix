{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cascadia-code";
  version = "2407.24";

  src = fetchzip {
    url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaCode-${version}.zip";
    stripRoot = false;
    hash = "sha256-bCQzGCvjSQ1TXFVC3w9VPXNtjM4h7lRvljVjX/w1TJ4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 otf/static/*.otf -t $out/share/fonts/opentype
    install -Dm644 ttf/static/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal";
    homepage = "https://github.com/microsoft/cascadia-code";
    changelog = "https://github.com/microsoft/cascadia-code/raw/v${version}/FONTLOG.txt";
    license = licenses.ofl;
    maintainers = with maintainers; [ ryanccn ];
    platforms = platforms.all;
  };
}
