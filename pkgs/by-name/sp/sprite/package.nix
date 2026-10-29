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
  version = "2026-10-20-hotfix.1";

  src = fetchurl {
    url = "https://sprites.dev/dl/client/${finalAttrs.version}/sprite-${
      if stdenv.hostPlatform.isLinux then "linux" else "macos"
    }-${if stdenv.hostPlatform.isx86_64 then "x86_64" else "aarch64"}";
    hash =
      {
        aarch64-darwin = "sha256-PwqCYRBuq9BHaHsqELdeTrFIsMF3ONgqHRur2G7d9mg=";
        aarch64-linux = "sha256-QPaJYk09BLcWC+6fSjVjgYvvqShmyfRmytr/vRxdDyI=";
        x86_64-linux = "sha256-c0j1RlL7zK6nnX60tXJC5h89ZXOSfeqqFCfbRGHQorI=";
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
    mainProgram = "sprite";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
