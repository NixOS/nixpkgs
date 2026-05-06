{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "function-runner";
  version = "9.1.2";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "function-runner";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KvReKvmF3i4zlfM8uj3KHamjfudcrhqrKGfK8O5tMpE=";
  };

  cargoHash = "sha256-gnEps/o+C8UpukO1oRF4qlhNsoAmyUmxMKGAgSykNY0=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  # Skip tests that require network.
  checkFlags = [
    "--skip=engine::tests::test_wasm_api_v1_function"
    "--skip=tests::run_wasm_api_v2_function"
    "--skip=tests::run_wasm_api_v1_function"
  ];

  meta = {
    description = "CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nintron ];
  };
})
