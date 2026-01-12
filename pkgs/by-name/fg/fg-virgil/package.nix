{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  woff2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fg-virgil";
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

    for file in packages/excalidraw/fonts/Virgil/*.woff2; do
      woff2_decompress $file
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 444 packages/excalidraw/fonts/Virgil/*.ttf -t $out/share/fonts/ttf
    install -D -m 444 packages/excalidraw/fonts/Virgil/*.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/excalidraw/virgil";
    description = "Font that powers Excalidraw";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.ofl;
  };
})
