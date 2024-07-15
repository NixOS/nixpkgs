{
  lib,
  fetchFromGitHub,
  rustPlatform,
  clang-tidy-sarif,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "clang-tidy-sarif";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "clang-tidy-sarif-v${version}";
    hash = "sha256-RnoJfmkrqdhOioGkB7rTzHQ3kx9vIRfWDJN30/8JAvM=";
  };

  cargoHash = "sha256-zH0d519vld00opTRWPyL78WKXPYJ+7uTjcDnjDl8hjE=";
  cargoBuildFlags = [
    "--package"
    "clang-tidy-sarif"
  ];
  cargoTestFlags = cargoBuildFlags;

  passthru = {
    tests.version = testers.testVersion { package = clang-tidy-sarif; };
  };

  meta = {
    description = "A CLI tool to convert clang-tidy diagnostics into SARIF";
    mainProgram = "clang-tidy-sarif";
    homepage = "https://psastras.github.io/sarif-rs";
    maintainers = with lib.maintainers; [ getchoo ];
    license = lib.licenses.mit;
  };
}
