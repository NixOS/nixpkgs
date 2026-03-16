{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dtop";
  version = "0.6.14";

  src = fetchFromGitHub {
    owner = "amir20";
    repo = "dtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nWSV91cvfWSTzseTFEVlVKHOa4ZsDDFt9r6L3yLjWZ8=";
  };

  cargoHash = "sha256-xJ4d+Nul8B9mE6Rlf5kg0nLuZWTmpbPnjpE0hUAME6U=";

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
