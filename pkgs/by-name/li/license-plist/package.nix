{
  lib,
  stdenvNoCC,
  fetchzip,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "license-plist";
  version = "3.27.7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/mono0926/LicensePlist/releases/download/${finalAttrs.version}/portable_licenseplist.zip";
    hash = "sha256-Z8jDFRZj0s6X+edexNZ0Qx2qUC8Bm2GC9uOrKWbXtCI=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 license-plist $out/bin/license-plist
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "License list generator for iOS application dependencies";
    homepage = "https://github.com/mono0926/LicensePlist";
    changelog = "https://github.com/mono0926/LicensePlist/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "license-plist";
    maintainers = with lib.maintainers; [ jeremystucki ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
