{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo-expand,
}:
rustPlatform.buildRustPackage rec {
  pname = "flutter_rust_bridge_codegen";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "fzyzcjy";
    repo = "flutter_rust_bridge";
    rev = "v${version}";
    hash = "sha256-pvKCiv7hUgetTXXp+NCs04Qo9xWaLUE2T1yHENhTGl4=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-efMA8VJaQlqClAmjJ3zIYLUfnuj62vEIBKsz0l3CWxA=";
  cargoBuildFlags = "--package flutter_rust_bridge_codegen";
  cargoTestFlags = "--package flutter_rust_bridge_codegen";

  # needed to get tests running
  nativeBuildInputs = [ cargo-expand ];

  # needed to run text (see https://github.com/fzyzcjy/flutter_rust_bridge/blob/ae970bfafdf80b9eb283a2167b972fb2e6504511/frb_codegen/src/library/utils/logs.rs#L43)
  logLevel = "debug";
  checkFlags = [
    # Disabled because these tests need a different version of anyhow than the package itself
    "--skip=tests::test_execute_generate_on_frb_example_dart_minimal"
    "--skip=tests::test_execute_generate_on_frb_example_pure_dart"
  ];

  meta = {
    mainProgram = "flutter_rust_bridge_codegen";
    description = "Flutter/Dart <-> Rust binding generator, feature-rich, but seamless and simple";
    homepage = "https://fzyzcjy.github.io/flutter_rust_bridge";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
  };
}
