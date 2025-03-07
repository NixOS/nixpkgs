{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  rust-jemalloc-sys,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "sqruff";
  version = "0.25.10";

  src = fetchFromGitHub {
    owner = "quarylabs";
    repo = "sqruff";
    tag = "v${version}";
    hash = "sha256-tCx+AeTLssXYXKBa7xwuddM8TPiIU6qaxrXeMTqrE0g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-I7DiJqVKHtSxBE2C9/oKOmogG56a7tAdg02YjQ0MbTI=";

  buildInputs = [
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.CoreServices ];

  # Disable the `python` feature which doesn't work on Nix yet
  buildNoDefaultFeatures = true;
  # The jinja and dbt template engines require the `python` feature which we disabled, so we disable these tests
  patches = [
    ./disable-templaters-test.diff
    ./disable-ui_with_dbt-test.diff
    ./disable-ui_with_jinja-test.diff
    ./disable-ui_with_python-test.diff
  ];

  # Patch the tests to find the sqruff binary
  postPatch = ''
    substituteInPlace \
      crates/cli/tests/config_not_found.rs \
      crates/cli/tests/configure_rule.rs \
      crates/cli/tests/fix_parse_errors.rs \
      crates/cli/tests/fix_return_code.rs \
      crates/cli/tests/ui_github.rs \
      crates/cli/tests/ui_json.rs \
      crates/cli/tests/ui.rs \
      --replace-fail \
      'sqruff_path.push(format!("../../target/{}/sqruff", profile));' \
      'sqruff_path.push(format!("../../target/${stdenv.hostPlatform.rust.cargoShortTarget}/{}/sqruff", profile));'
  '';

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
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
    maintainers = with lib.maintainers; [ hasnep ];
  };
}
