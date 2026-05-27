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
  version = "0.17.0";

  src = fetchFromCodeberg {
    owner = "mergiraf";
    repo = "mergiraf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tqz1gNg2XIYO/dFETajF3XUs3A1+mY82U4pz+mMb/ws=";
  };

  cargoHash = "sha256-8Geu6Cd83hTnd53/ZTKq1YIEMIX4oIgwzSS6h8RNaP8=";

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
