{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "styx-cli";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "bearcove";
    repo = "styx";
    tag = "styx-cli-v${finalAttrs.version}";
    hash = "sha256-1XS1voPdqr2GJSsOdm93alknS5vwdoFi1WF9bzMCf0o=";
  };

  cargoHash = "sha256-7eqw0Qjj2VV2KYGSOVoLl8nyuMCTMpLte2lVL7MQPpI=";

  cargoBuildFlags = [
    "--package"
    "styx-cli"
  ];

  checkFlags = [
    # These tests don't like nix's build environment
    "--skip=error::tests::test_missing_field_diagnostic"
    "--skip=error::tests::test_unknown_field_diagnostic"
    "--skip=error::tests::test_ariadne_config_respects_no_color_env"
    "--skip=error::tests::test_invalid_scalar_diagnostic"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex"
      "styx-cli-v(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/bearcove/styx/releases/tag/styx-cli-v${finalAttrs.version}";
    description = "Document language for mortals";
    downloadPage = "https://github.com/bearcove/styx";
    homepage = "https://styx.bearcove.eu/";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "styx";
  };
})
