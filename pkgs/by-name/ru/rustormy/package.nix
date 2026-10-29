{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustormy";
  version = "0.5.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tairesh";
    repo = "rustormy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LC6hHxCG9TnXcRIxg2jAt6+r8Rm6Iu/TiX/neW5d4fk=";
  };

  cargoHash = "sha256-cvL+OAiGidQEltM/cgjzjeEFbM7IZvhIG5Q3Nxybb1w=";

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
    maintainers = with lib.maintainers; [ joseg313 ];
  };

})
