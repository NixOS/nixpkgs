{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "numr";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "nasedkinpv";
    repo = "numr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jpHkKqALN85rbSswU1/nRUi064VKkbbDoNoeyXOhTWU=";
  };

  cargoHash = "sha256-x0frzDiD2kr0geNOZagc1n7bs0UH6StG1Va0Q5EQFl4=";

  checkFlags = [
    # Skip tests that require network access
    "--skip=fetch::tests::test_build_crypto_prices_request_adds_query_params"
    "--skip=fetch::tests::test_build_crypto_prices_request_skips_api_key_for_non_coingecko_url"
    "--skip=fetch::tests::test_build_crypto_prices_request_uses_demo_api_key_header"
    "--skip=fetch::tests::test_build_crypto_prices_request_uses_pro_api_key_header"
    # "Operation not permitted"
    "--skip=persistence::tests::private_overwrite_preserves_file_and_existing_directory_modes"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  # "No CA certificates were loaded from the system"
  nativeCheckInputs = [ cacert ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text calculator inspired by Numi - natural language expressions, variables, unit conversions";
    homepage = "https://github.com/nasedkinpv/numr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    badPlatforms = lib.platforms.darwin;
    # the crate `...` requires panic strategy `abort` which is incompatible with this crate's strategy of `unwind`
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "numr";
  };
})
