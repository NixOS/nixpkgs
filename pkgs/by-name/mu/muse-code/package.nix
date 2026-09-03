{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  manifest = lib.importJSON ./manifest.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "muse-code";
  version = manifest.version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl manifest.assets.${stdenv.hostPlatform.system};

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/muse

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";

  # The macOS binary is notarized; fixups would invalidate its signature.
  dontFixup = stdenv.hostPlatform.isDarwin;

  passthru.updateScript = ./update.py;

  meta = {
    description = "Coding agent for complex coding workstreams";
    homepage = "https://developer.meta.com/ai/products/muse-code/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ aaronjheng ];
    platforms = builtins.attrNames manifest.assets;
    mainProgram = "muse";
  };
})
