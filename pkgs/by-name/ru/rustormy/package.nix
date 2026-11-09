{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustormy";
  version = "0.5.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tairesh";
    repo = "rustormy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-03xvbtwZ3KqK36+N71wGTEsZl3Yyfl/JnLMCuBDu53w=";
  };

  cargoHash = "sha256-wKv198Clvhk8BbnbfPoP/v5YOb4zAMtMNK/pFq1BelA=";

  checkFlags = [
    "--skip=tests::test_different_units"
    "--skip=tests::test_empty_city"
    "--skip=tests::test_no_location_provided"
    "--skip=tests::test_nonexistent_city"
    "--skip=tests::test_valid_city_lookup"
    "--skip=tests::test_valid_coordinates"
    "--skip=weather::enrich::tests::does_not_overwrite_false_is_day_when_set"
    "--skip=weather::enrich::tests::does_not_overwrite_true_is_day_when_set"
    "--skip=weather::enrich::tests::does_not_overwrite_uv_when_set"
    "--skip=weather::enrich::tests::fills_is_day_when_none"
    "--skip=weather::enrich::tests::openuv_failure_does_not_break_enrich"
    "--skip=weather::enrich::tests::skips_uv_when_openuv_key_empty"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Minimal neofetch-like weather CLI";
    homepage = "https://github.com/tairesh/rustormy";
    license = lib.licenses.mit;
    mainProgram = "rustormy";
    maintainers = with lib.maintainers; [
      joseg313
      ethancedwards8
    ];
  };

})
