{
  lib,
  fetchFromGitea,
  rustPlatform,
  nix-update-script,

  # native check inputs
  git,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mergiraf";
  version = "0.11.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mergiraf";
    repo = "mergiraf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nzWRMCIeZ1RmZO4v5UqX1JrbN1UjBHkl/bYaERCzfew=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9OjcEmed9nLM/fp6Qk/Gh9hTVnn5cqCxTUpAJUkI4/M=";

  nativeCheckInputs = [ git ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Syntax-aware git merge driver for a growing collection of programming languages and file formats";
    homepage = "https://mergiraf.org/";
    downloadPage = "https://codeberg.org/mergiraf/mergiraf";
    changelog = "https://codeberg.org/mergiraf/mergiraf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      zimbatm
      genga898
      defelo
    ];
    mainProgram = "mergiraf";
  };
})
