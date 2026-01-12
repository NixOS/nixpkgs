{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  woff2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "excalifont";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "excalidraw";
    repo = "excalidraw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nfzh5rNvHP7R418PP44FXD7xNenzmzMHu7RLAdJsE/c=";
  };

  nativeBuildInputs = [
    woff2
  ];

  buildPhase = ''
    runHook preBuild

    for file in packages/excalidraw/fonts/Excalifont/*.woff2; do
      woff2_decompress $file
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 444 packages/excalidraw/fonts/Excalifont/*.ttf -t $out/share/fonts/ttf
    install -D -m 444 packages/excalidraw/fonts/Excalifont/*.woff2 -t $out/share/fonts/woff2

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
