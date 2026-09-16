{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  esbuild,
  makeWrapper,
  versionCheckHook,
  librusty_v8 ? callPackage ./librusty_v8.nix { },
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "celld";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = "celld";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iew3/ugHftS1Ui6tiVRPj3FguYmGx9vwMfS6pY00CWQ=";
  };

  cargoHash = "sha256-g3b2gFeHkqlUVLydWs/HiieK2dtw7BC2o9eNwCGAHT0=";

  __structuredAttrs = true;

  __darwinAllowLocalNetworking = true;

  env.RUSTY_V8_ARCHIVE = librusty_v8;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/celld \
      --set-default CELLD_ESBUILD ${lib.getExe esbuild}
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    inherit librusty_v8;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Self-hosted, distributed Durable Objects runtime";
    homepage = "https://celld.dev";
    changelog = "https://github.com/denoland/celld/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ akosseres ];
    mainProgram = "celld";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
