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
  version = "2026-10-20";

  src = fetchurl {
    url = "https://sprites.dev/dl/client/${finalAttrs.version}/sprite-${
      if stdenv.hostPlatform.isLinux then "linux" else "macos"
    }-${if stdenv.hostPlatform.isx86_64 then "x86_64" else "aarch64"}";
    hash =
      {
        aarch64-darwin = "sha256-K1BuaGDZM2VKF26rU1WlYV8gi7lAh8RLbk/Nfw4trEU=";
        aarch64-linux = "sha256-wklCt9euTfY0Iu/RHU3/7rw3Fuk5FpGL6KJa0IiE3Fw=";
        x86_64-linux = "sha256-0SSkCc/bcyHvswm5flFZkftbDn5fEZ5jYdf94qLUCC8=";
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
