{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  nix-update-script,

  # native check inputs
  git,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mergiraf";
  version = "0.16.3";

  src = fetchFromCodeberg {
    owner = "mergiraf";
    repo = "mergiraf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KlielG8XxOlS5Np8LZT+GMujWw/7EDOwsZHWVjneV3g=";
  };

  cargoHash = "sha256-F6YtOgcAR4fN33j7Ae4ixhTfNctUfgkV3t1I7XJzHHw=";

  nativeCheckInputs = [ git ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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
