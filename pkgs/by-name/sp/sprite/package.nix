{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  autoPatchelfHook,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sprite";
  version = "0.0.1-rc39";

  src = fetchurl {
    url = "https://sprites-binaries.t3.storage.dev/client/v${finalAttrs.version}/sprite-${
      if stdenv.hostPlatform.isLinux then "linux" else "darwin"
    }-${if stdenv.hostPlatform.isx86_64 then "amd64" else "arm64"}.tar.gz";
    hash =
      {
        aarch64-darwin = "sha256-maYdqZP4PLheuMVwZoyf/S7+8j47+LSsZrSf8KWoCsc=";
        x86_64-darwin = "sha256-VTKOBfWqJVyV182KI63Viaw7W9yVjGz9P4uJT7STKgM=";
        aarch64-linux = "sha256-3eAE8oh/wn/2sBB7CgnbPyugM3TS6wetpEoi+LmtBwk=";
        x86_64-linux = "sha256-jc/NC62zu6/cPjXOtWRbt/xgduE3mKr6W/trfMrBa5Y=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  unpackPhase = ''
    tar xf $src
  '';

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 sprite $out/bin/
  '';

  passthru.updateScript = ./update.sh;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
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
