{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "numr";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "nasedkinpv";
    repo = "numr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XhlJ3YhOJly/DknfifYriDzXfT/2Ii/S5uvACfjz7H8=";
  };

  cargoHash = "sha256-BVoFMDBCCZ9XYXOrT/nOFnqGOYqXC5omT3nYvoHUAAA=";

  checkFlags = [
    # Skip tests that require network access
    "--skip=fetch::tests::test_build_crypto_prices_request_adds_query_params"
    "--skip=fetch::tests::test_build_crypto_prices_request_skips_api_key_for_non_coingecko_url"
    "--skip=fetch::tests::test_build_crypto_prices_request_uses_demo_api_key_header"
    "--skip=fetch::tests::test_build_crypto_prices_request_uses_pro_api_key_header"
  ];

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
    badPlatforms = [ "aarch64-darwin" ];
    mainProgram = "numr";
  };
})
