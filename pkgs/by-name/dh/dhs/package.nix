{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dhs";
  version = "1.6.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/objective-see/DylibHijackScanner/releases/download/v${finalAttrs.version}/DHS_${finalAttrs.version}.zip";
    hash = "sha256-/hK97BtFdwlll0+MiF9UirSGghm1Z9pPTuwFVuuyk6Q=";

    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R DHS.app "$out/Applications/DHS.app"

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/Applications/DHS.app/Contents/MacOS/DHS $out/bin/dhs
  '';

  dontFixup = true; # Preserve upstream's notarized app bundle and system extension signature.

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "dhs";
    description = "Dylib Hijack Scanner";
    longDescription = ''
      Dylib Hijack Scanner or DHS, is a simple utility that will scan
      your computer for applications that are either susceptible to
      dylib hijacking or have been hijacked.
    '';
    homepage = "https://objective-see.org/products/dhs.html";
    downloadPage = "https://github.com/objective-see/DylibHijackScanner/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/objective-see/DylibHijackScanner/releases";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "objective-see";
        product = "dhs";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "github";
        namespace = "objective-see";
        name = "dhs";
        version = finalAttrs.version;
      };
    };
    maintainers = with lib.maintainers; [
      KristijanZic
    ];
  };
})
