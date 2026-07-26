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
  version = "0.0.1-rc46";

  src = fetchurl {
    url = "https://sprites-binaries.t3.storage.dev/client/v${finalAttrs.version}/sprite-${
      if stdenv.hostPlatform.isLinux then "linux" else "darwin"
    }-${if stdenv.hostPlatform.isx86_64 then "amd64" else "arm64"}.tar.gz";
    hash =
      {
        aarch64-darwin = "sha256-q7GzIi55W6esVYepqgI9hUCziZlL/Fx1mDd1J1aqkWI=";
        aarch64-linux = "sha256-c7ldoDrCbGjT1kps/UgYfSAskyu+LYkywpwTpzfpYVw=";
        x86_64-linux = "sha256-uOUcgW6W1xv4GXVnDnDeKOXJ9OgYQu8UdmKQXiEqTco=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 sprite $out/bin/
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
