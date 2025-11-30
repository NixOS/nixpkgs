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
  version = "0.16.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mergiraf";
    repo = "mergiraf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vKqvVpGyQ9ayebssupiySjJ7R7gn1W8HTlDuGM4d1Ns=";
  };

  cargoHash = "sha256-vhes4p8e1PW4p5tqqPffAgl3V4dK17+n748VA6Q23lE=";

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
