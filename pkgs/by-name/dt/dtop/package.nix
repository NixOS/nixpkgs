{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dtop";
  version = "0.6.12";

  src = fetchFromGitHub {
    owner = "amir20";
    repo = "dtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OUK/5Xsy6T24iGbpDsSFaKX58B5HsSHh947xPLx9jnI=";
  };

  cargoHash = "sha256-E2CpLOIqw98ftqeFKODvwW53RP7L7JPd6acpwGuOOA4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal dashboard for Docker monitoring across multiple hosts with Dozzle integration";
    homepage = "https://dtop.dev/";
    downloadPage = "https://github.com/amir20/dtop";
    changelog = "https://github.com/amir20/dtop/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "dtop";
  };
})
