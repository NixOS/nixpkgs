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
  version = "0.0.1-rc43";

  src = fetchurl {
    url = "https://sprites-binaries.t3.storage.dev/client/v${finalAttrs.version}/sprite-${
      if stdenv.hostPlatform.isLinux then "linux" else "darwin"
    }-${if stdenv.hostPlatform.isx86_64 then "amd64" else "arm64"}.tar.gz";
    hash =
      {
        aarch64-darwin = "sha256-6ztxc59b2H76+o7k7zMOvA/PAOib4m7WRXo1XsigL04=";
        x86_64-darwin = "sha256-Ni779eJIFbZQ/zrAA3zQyYFFQ7ikEU9UYL9GeO1OcKA=";
        aarch64-linux = "sha256-YTNHlVknlVkyUsiI422Quo04CyIMxCbrjhPvGADHw2s=";
        x86_64-linux = "sha256-wEClvx4Kv7WK4uMYwNJqvsvjyQsonI01xlCo3z7CuwQ=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  sourceRoot = ".";

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
