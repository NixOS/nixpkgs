{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprocs";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = "mprocs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-77uXHlQjhIDbRbnkr3jvZKuLOcvbOIuum8FRsUv8cYw=";
  };

  cargoHash = "sha256-T8zG2Z7UP4MZUGeUypG9ugO49rbicwYrdRZiGJN3H0E=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    changelog = "https://github.com/pvolok/mprocs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.unix;
    mainProgram = "mprocs";
  };
})
