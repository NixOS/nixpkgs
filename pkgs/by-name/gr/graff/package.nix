{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
}:

let
  manifest = lib.importJSON ./manifest.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "graff";
  version = manifest.version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl (manifest.assets.${stdenv.hostPlatform.system});

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 graff -t $out/bin
    install -Dm644 LICENSE -t $out/share/doc/graff

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # The macOS binary is notarized; fixups would invalidate its signature.
  dontFixup = stdenv.hostPlatform.isDarwin;

  passthru.updateScript = ./update.py;

  meta = {
    description = "Fast agentic coding harness in Zig";
    homepage = "https://codegraff.com";
    changelog = "https://github.com/justrach/codegraff/releases/tag/v${manifest.version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ aaronjheng ];
    platforms = builtins.attrNames manifest.assets;
    mainProgram = "graff";
  };
})
