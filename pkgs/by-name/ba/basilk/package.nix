{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "basilk";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "gabalpha";
    repo = "basilk";
    tag = finalAttrs.version;
    hash = "sha256-ZicrgRghUvKp42H03IV1mUIV8FN5cfEx7ncqZMi9t9o=";
  };

  cargoHash = "sha256-e0zPA+DB1z2J0fIbIgHMSvrpyeglBssIx1Axp7TpQsw=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal User Interface (TUI) to manage your tasks with minimal kanban logic";
    homepage = "https://github.com/gabalpha/basilk";
    changelog = "https://github.com/GabAlpha/basilk/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thtrf ];
    mainProgram = "basilk";
  };
})
