{
  lib,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  rustPlatform,
  pkg-config,
  aws-lc,
  openssl,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "function-runner";
  version = "9.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "function-runner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3oXz9o9riY8P0dAdBMJzRE7FEP3janrfBLLff1J9Lu0=";
  };

  cargoHash = "sha256-31X0+7RJcpw4O8SZISQpzN/r7OOcrR8XOYlSSQwvxsU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    aws-lc
    openssl
    zstd
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # Failed to download trampoline: error sending request for url
  checkFlags = map (t: "--skip=${t}") [
    "engine::tests::test_wasm_api_v1_function"
    "tests::run_wasm_api_v1_function"
    "tests::run_wasm_api_v2_function"
  ];

  meta = {
    description = "CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    homepage = "https://github.com/Shopify/function-runner";
    changelog = "https://github.com/Shopify/function-runner/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nintron
      kybe236
    ];
    mainProgram = "function-runner";
  };
})
