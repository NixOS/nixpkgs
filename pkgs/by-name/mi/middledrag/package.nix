{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "middledrag";
  version = "1.4.2.3";

  src = fetchurl {
    url = "https://github.com/NullPointerDepressiveDisorder/MiddleDrag/releases/download/v${finalAttrs.version}/MiddleDrag-${finalAttrs.version}.pkg";
    hash = "sha256-HQVmbUAhcWqJAkFUlSIv5u4E8k2j9owX8H+Yp3cM5BU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    xar
    cpio
  ];

  unpackPhase = ''
    runHook preUnpack
    xar -x -f $src
    cat Payload | gunzip -dc | cpio -i
    runHook postUnpack
  '';

  sourceRoot = "Applications/MiddleDrag.app";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r . $out/Applications/MiddleDrag.app
    runHook postInstall
  '';

  meta = {
    description = "Three-finger click and drag simulation for macOS trackpads";
    homepage = "https://middledrag.app";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nullpointerdepressivedisorder ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "MiddleDrag";
    platforms = lib.platforms.darwin;
  };
})
