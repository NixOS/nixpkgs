{
  lib,
  stdenvNoCC,
  fetchurl,

  makeWrapper,
  unzip,

  github-desktop,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "github-desktop-bin";
  version = "3.6.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl finalAttrs.passthru.source;

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r * $out/Applications
    makeWrapper \
      $out/Applications/GitHub\ Desktop.app/Contents/MacOS/GitHub\ Desktop \
      $out/bin/github-desktop

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    source = lib.importJSON ./source.json;
  };

  meta = {
    inherit (github-desktop.meta) description homepage;
    maintainers = [ lib.maintainers.dtomvan ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
