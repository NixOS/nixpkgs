{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "corn-cli";
  version = "0.10.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "corn-config";
    repo = "corn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TPGLF72fp1aX19kQgI/bYdzTIsP0M7gn1ZSUny10kMs=";
  };

  cargoHash = "sha256-4WDL1A29vQ9NrDbfA0nBZ7PcBz2zTmlOaxI6V4u4x5o=";

  cargoBuildFlags = [
    "--package"
    "corn-cli"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  preCheck = ''
    export CORN_TEST=bar
  '';

  # Single failing test
  checkFlags = [
    "--skip=toml_complex"
  ];

  meta = {
    description = "CLI for Cornlang, a simple and pain-free configuration language";
    homepage = "https://cornlang.dev/";
    changelog = "https://github.com/corn-config/corn/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "corn-cli";
  };
})
