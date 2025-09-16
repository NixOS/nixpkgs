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
  version = "0.14.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mergiraf";
    repo = "mergiraf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ad5A3d/E1PyfI1/vKdHmiVcDokPSiGoMfg1eXKCbhtA=";
  };

  cargoHash = "sha256-8zOEFGkrlyaZMRbTzFVk3CujC1LlAxKqGslwZyjXoKw=";

  nativeCheckInputs = [ git ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  cargoBuildFlags = [
    # don't install the `mgf_dev`
    "--bin"
    "mergiraf"
  ];

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
