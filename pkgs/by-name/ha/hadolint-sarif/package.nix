{
  lib,
  fetchFromGitHub,
  rustPlatform,
  hadolint-sarif,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "hadolint-sarif";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "hadolint-sarif-v${version}";
    hash = "sha256-RnoJfmkrqdhOioGkB7rTzHQ3kx9vIRfWDJN30/8JAvM=";
  };

  cargoHash = "sha256-x2JHMc8OcOVCJ0X68tTyMI8P7bM8javjkYlrHBLMjus=";
  cargoBuildFlags = [
    "--package"
    "hadolint-sarif"
  ];
  cargoTestFlags = cargoBuildFlags;

  passthru = {
    tests.version = testers.testVersion { package = hadolint-sarif; };
  };

  meta = {
    description = "A CLI tool to convert hadolint diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    mainProgram = "hadolint-sarif";
    maintainers = with lib.maintainers; [ getchoo ];
    license = lib.licenses.mit;
  };
}
