{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "sqruff";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "quarylabs";
    repo = "sqruff";
    tag = "v${version}";
    hash = "sha256-Yk4ejrIs8/8RVvXS2V2ZTBn6zawVO502Xeeb8rjU6e4=";
  };

  cargoHash = "sha256-4jB1chciQaR/RYhRTfwWOOUIZgePezl8lAngpfoSuJc=";

  # Disable the `python` feature which doesn't work on Nix yet
  buildNoDefaultFeatures = true;
  buildAndTestSubdir = "crates/cli";

  # Patch the tests to find the sqruff binary
  postPatch = ''
    substituteInPlace \
      crates/cli/tests/config_not_found.rs \
      crates/cli/tests/configure_rule.rs \
      crates/cli/tests/dialect_override.rs \
      crates/cli/tests/fix_parse_errors.rs \
      crates/cli/tests/fix_return_code.rs \
      crates/cli/tests/ignore_data_directory.rs \
      crates/cli/tests/verbose_logging_ignore.rs \
      crates/cli/tests/ui_github.rs \
      crates/cli/tests/ui_json.rs \
      crates/cli/tests/ui.rs \
      --replace-fail \
      '"../../target/{}/sqruff"' \
      '"../../target/${stdenv.hostPlatform.rust.cargoShortTarget}/{}/sqruff"'
  '';

  nativeCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast SQL formatter/linter";
    homepage = "https://github.com/quarylabs/sqruff";
    changelog = "https://github.com/quarylabs/sqruff/releases/tag/${version}";
    license = lib.licenses.asl20;
    mainProgram = "sqruff";
    maintainers = with lib.maintainers; [
      hasnep
      pyrox0
    ];
  };
}
