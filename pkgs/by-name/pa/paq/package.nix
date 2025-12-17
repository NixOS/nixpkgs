{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paq";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "gregl83";
    repo = "paq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cG1xoe0mtijR5l1T2O/6C6yTdGhSXxYaGGugllOOZoE=";
  };

  cargoHash = "sha256-M3UtXCX4caYYaXoS8F2kKheP5qX5xac2WPNCnw94B6Q=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hash file or directory recursively";
    homepage = "https://github.com/gregl83/paq";
    changelog = "https://github.com/gregl83/paq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lafrenierejm ];
    mainProgram = "paq";
  };
})
