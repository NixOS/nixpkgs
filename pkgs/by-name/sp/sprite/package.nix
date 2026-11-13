{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  autoPatchelfHook,
  writableTmpDirAsHomeHook,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sprite";
  version = "2026-11-03";

  src = fetchurl {
    url = "https://sprites.dev/dl/client/${finalAttrs.version}/sprite-${
      if stdenv.hostPlatform.isLinux then "linux" else "macos"
    }-${if stdenv.hostPlatform.isx86_64 then "x86_64" else "aarch64"}";
    hash =
      {
        aarch64-darwin = "sha256-cR1q85SAd6HD5HZYp0wdjn59MfvGKDRekMoyq06auWA=";
        aarch64-linux = "sha256-yCyDv+0o5LZ8LGv2Owrsua3cTFaOzLau85nyG/zG1IY=";
        x86_64-linux = "sha256-cxr0d+z3Mo/RiMZ7NkmHTJEHtvAJfCWIjQ3Req2CNSc=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 $src $out/bin/sprite
    wrapProgram $out/bin/sprite --set UPGRADE_CHECK false
  '';

  passthru.updateScript = ./update.sh;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = "HOME";
  doInstallCheck = true;

  meta = {
    description = "Command Line Interactive for sprites, stateful sandbox environments with checkpoint & restore";
    homepage = "https://sprites.dev";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "sprite";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
