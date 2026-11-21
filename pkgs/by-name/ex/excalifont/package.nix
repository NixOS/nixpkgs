{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  woff2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "excalifont";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "excalidraw";
    repo = "cli";
    rev = "d1e716f1aef2c2417772366b3869bbaee7b385c6";
    hash = "sha256-ViuUVCpGJmzJQWQiGdDWfbNmjZNfqIpG35G4b3JHG/s=";
  };

  nativeBuildInputs = [
    woff2
  ];

  buildPhase = ''
    runHook preBuild

    cp .github/assets/banner/Excalifont.woff2 Excalifont-Regular.woff2
    woff2_decompress Excalifont-Regular.woff2

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 444 Excalifont-Regular.ttf -t $out/share/fonts/ttf
    install -D -m 444 Excalifont-Regular.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = {
    homepage = "https://plus.excalidraw.com/excalifont";
    description = "Font based on the original handwritten Virgil font carefully curated to improve legibility while preserving its hand-drawn nature";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.ofl;
  };
})
