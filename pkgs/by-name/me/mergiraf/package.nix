{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  nix-update-script,

  # native check inputs
  git,
  jujutsu,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mergiraf";
  version = "0.18.0";

  src = fetchFromCodeberg {
    owner = "mergiraf";
    repo = "mergiraf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PfGiPH7CU8z+Flj3X04XnRdWcv5K+hTZMfvHpM52Fic=";
  };

  cargoHash = "sha256-1MDjaaH2PcvQz0DKSTADRB+8YEUWP1GN2edHk4EDVGA=";

  nativeCheckInputs = [
    git
    jujutsu
  ];

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
