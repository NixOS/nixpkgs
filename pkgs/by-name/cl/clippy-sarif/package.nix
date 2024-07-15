{
  lib,
  fetchFromGitHub,
  rustPlatform,
  clippy,
  clippy-sarif,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "clippy-sarif";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "clippy-sarif-v${version}";
    hash = "sha256-RnoJfmkrqdhOioGkB7rTzHQ3kx9vIRfWDJN30/8JAvM=";
  };

  cargoHash = "sha256-F97Cwk87M3SpLqXSECH5nZ8x+3c3oz28zxlPvQUZWlg=";
  cargoBuildFlags = [
    "--package"
    "clippy-sarif"
  ];
  cargoTestFlags = cargoBuildFlags;

  passthru = {
    tests.version = testers.testVersion { package = clippy-sarif; };
  };

  meta = {
    description = "A CLI tool to convert clippy diagnostics into SARIF";
    mainProgram = "clippy-sarif";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    inherit (clippy.meta) platforms;
  };
}
