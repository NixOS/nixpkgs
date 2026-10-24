{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "orion-browser";
  version = "151";

  src = fetchurl {
    url = "https://cdn.kagi.com/updates/26_0/${finalAttrs.version}.zip";
    hash = "sha256-d6Va5mwN+ulAaFbo4dIKENzQammRdfkFnqOV2zmPgQA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  unpackCmd = "unzip -q $curSrc -x '__MACOSX/*'";

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R Orion.app "$out/Applications"
    makeWrapper "$out/Applications/Orion.app/Contents/MacOS/Orion" "$out/bin/orion"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "WebKit-based web browser by Kagi";
    homepage = "https://orionbrowser.com/";
    changelog = "https://orionbrowser.com/updates/orion-release-notes";
    license = lib.licenses.unfree;
    mainProgram = "orion";
    maintainers = with lib.maintainers; [ pradyuman ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
