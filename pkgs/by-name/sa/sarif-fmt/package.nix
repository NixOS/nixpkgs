{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  clippy,
  sarif-fmt,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "sarif-fmt";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "sarif-fmt-v${version}";
    hash = "sha256-RnoJfmkrqdhOioGkB7rTzHQ3kx9vIRfWDJN30/8JAvM=";
  };

  cargoHash = "sha256-VonkXSeyp8Kxo5mE+eI5ialgqcCFvDALv/XXl2i8DZ0=";
  cargoBuildFlags = [
    "--package"
    "sarif-fmt"
  ];
  cargoTestFlags = cargoBuildFlags;

  # `test_clippy` (the only test we enable) is broken on Darwin
  # because `--enable-profiler` is not enabled in rustc on Darwin
  # error[E0463]: can't find crate for profiler_builtins
  doCheck = !stdenv.isDarwin;

  nativeCheckInputs = [
    # `test_clippy`
    clippy
  ];

  checkFlags = [
    # this test uses nix so...no go
    "--skip=test_clang_tidy"
    # ditto
    "--skip=test_hadolint"
    # ditto
    "--skip=test_shellcheck"
  ];

  passthru = {
    tests.version = testers.testVersion { package = sarif-fmt; };
  };

  meta = {
    description = "A CLI tool to pretty print SARIF diagnostics";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "sarif-fmt";
  };
}
