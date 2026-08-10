{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kextviewr";
  version = "2.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/objective-see/KextViewr/releases/download/v${finalAttrs.version}/KextViewr_${finalAttrs.version}.zip";
    hash = "sha256-caTfGRmp8XycOC6+ev1EsDQd4etLVvE9Nb32Nqj27zw=";

    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R KextViewr.app "$out/Applications/KextViewr.app"

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/Applications/KextViewr.app/Contents/MacOS/KextViewr $out/bin/kextviewr
  '';

  dontFixup = true; # Preserve upstream's notarized app bundle and system extension signature.

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "kextviewr";
    description = "KextViewr is a simple utility that shows you all modules on that are loaded in the OS kernel";
    longDescription = ''
      For each loaded kext, it provides information such as their
      collection (boot, auxiliary, etc.), size, address, and more.
    '';
    homepage = "https://objective-see.org/products/kextviewr.html";
    downloadPage = "https://github.com/objective-see/KextViewr/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/objective-see/KextViewr/releases";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "objective-see";
        product = "kextviewr";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "github";
        namespace = "objective-see";
        name = "kextviewr";
        version = finalAttrs.version;
      };
    };
    maintainers = with lib.maintainers; [
      KristijanZic
    ];
  };
})
