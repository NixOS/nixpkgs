{
  lib,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "function-runner";
  version = "9.1.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "function-runner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KvReKvmF3i4zlfM8uj3KHamjfudcrhqrKGfK8O5tMpE=";
  };

  cargoHash = "sha256-gnEps/o+C8UpukO1oRF4qlhNsoAmyUmxMKGAgSykNY0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ openssl ];

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
