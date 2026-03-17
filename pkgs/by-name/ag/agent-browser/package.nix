{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agent-browser";
  version = "0.20.14";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G6tLoTAtIW1x5Wrflf1E4kdhhZw1PaIZiw+gVvbj79A=";
  };

  cargoRoot = "cli";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-Oq1EoTrH3arvnsa69RP5TZ3pF9bWG6pgU3GWh3CyoY0=";

  # Tests require a running Chrome browser which isn't available in the sandbox
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Headless browser automation CLI for AI agents";
    homepage = "https://github.com/vercel-labs/agent-browser";
    changelog = "https://github.com/vercel-labs/agent-browser/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ecklf ];
    mainProgram = "agent-browser";
    platforms = lib.platforms.unix;
  };
})
