{
  lib,
  stdenvNoCC,
  fetchzip,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "periphery";
  version = "3.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/peripheryapp/periphery/releases/download/${finalAttrs.version}/periphery-${finalAttrs.version}.zip";
    hash = "sha256-WyuSYzFFUesHSmvZUa8Iw6f5BECKFJ0PVBylcq2uxz8=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 periphery $out/bin/periphery
    install -Dm755 libIndexStore.dylib $out/bin/libIndexStore.dylib
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unused code detector for Swift projects";
    homepage = "https://github.com/peripheryapp/periphery";
    changelog = "https://github.com/peripheryapp/periphery/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "periphery";
    maintainers = with lib.maintainers; [ jeremystucki ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
