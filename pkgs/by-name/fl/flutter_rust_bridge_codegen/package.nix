{
  lib,
  fetchFromGitHub,
  rustPlatform,
  flutter,
  cargo-expand,
}:

rustPlatform.buildRustPackage rec {
  pname = "flutter_rust_bridge_codegen";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "fzyzcjy";
    repo = "flutter_rust_bridge";
    rev = "v${version}";
    hash = "sha256-U7Z349D3U83YLrcwSh2zMTNPScxtXpEM2n/H/S0RqhY=";
  };

  cargoHash = "sha256-b+duVR3vn1HrhUcVucHfzjTDhbru3+IYVNS3ji6LGto=";
  cargoTestFlags = "--package ${pname}";
  cargoBuildFlags = "--package ${pname}";

  nativeBuildInputs = [ cargo-expand ];
  buildInputs = [ flutter ];

  # needed to run text (see https://github.com/fzyzcjy/flutter_rust_bridge/blob/ae970bfafdf80b9eb283a2167b972fb2e6504511/frb_codegen/src/library/utils/logs.rs#L43)
  logLevel = "debug";
  checkFlags = [
    # Disabled because these tests need a different version of anyhow than the package itself
    "--skip=tests::test_execute_generate_on_frb_example_dart_minimal"
    "--skip=tests::test_execute_generate_on_frb_example_pure_dart"
  ];

  meta = {
    description = "Flutter/Dart <-> Rust binding generator, feature-rich, but seamless and simple";
    homepage = "https://fzyzcjy.github.io/flutter_rust_bridge/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
  };
}
