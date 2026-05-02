{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "macshot";
  version = "4.0.4";

  src = fetchurl {
    url = "https://github.com/sw33tLie/macshot/releases/download/v${finalAttrs.version}/MacShot.dmg";
    hash = "sha256-OiWj1kzwtGIGfxBxpNDYRcPJcOfxFjjj5/Gl+noN0j8=";
  };

  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R macshot.app "$out/Applications/"

    runHook postInstall
  '';

  dontBuild = true;
  dontFixup = true;

  __structuredAttrs = true;
  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The most feature-rich open-source screenshot tool on macOS.";
    longDescription = "Feature-packed native macOS screenshot tool: annotate, auto-redact PII, record GIFs, OCR + translate, scroll capture, beautify, and more. No Electron, no subscription.";
    homepage = "https://macshot.io/";
    changelog = "https://github.com/sw33tLie/macshot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ myzel394 ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
