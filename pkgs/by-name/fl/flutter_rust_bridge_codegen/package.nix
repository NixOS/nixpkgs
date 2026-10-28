{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo-expand,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flutter_rust_bridge_codegen";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "fzyzcjy";
    repo = "flutter_rust_bridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NMM5QyqoduhXMpV9b6b3qRpfwqWtHkoucVN4xO81+fw=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-xxdBo5rxuWiq5YMRPpVp2+0JX1lKvvzrT8z5Rq8S9g0=";
  cargoBuildFlags = [
    "--package"
    "flutter_rust_bridge_codegen"
  ];
  cargoTestFlags = [
    "--package"
    "flutter_rust_bridge_codegen"
  ];

  # needed to get tests running
  nativeBuildInputs = [ cargo-expand ];

  # needed to run text (see https://github.com/fzyzcjy/flutter_rust_bridge/blob/ae970bfafdf80b9eb283a2167b972fb2e6504511/frb_codegen/src/library/utils/logs.rs#L43)
  logLevel = "debug";
  checkFlags = [
    # Disabled because these tests need a different version of anyhow than the package itself
    "--skip=tests::test_execute_generate_on_frb_example_dart_minimal"
    "--skip=tests::test_execute_generate_on_frb_example_pure_dart"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Timeout on darwin, not related to networking in sandbox
    "--skip=library::codegen::controller::tests::test_run_with_watch"
    "--skip=library::codegen::generator::api_dart::tests::test_functions"
  ];

  meta = {
    mainProgram = "flutter_rust_bridge_codegen";
    description = "Flutter/Dart <-> Rust binding generator, feature-rich, but seamless and simple";
    homepage = "https://fzyzcjy.github.io/flutter_rust_bridge";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
  };
})
