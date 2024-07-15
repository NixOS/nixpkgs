{
  lib,
  fetchFromGitHub,
  rustPlatform,
  shellcheck-sarif,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "shellcheck-sarif";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "shellcheck-sarif-v${version}";
    hash = "sha256-RnoJfmkrqdhOioGkB7rTzHQ3kx9vIRfWDJN30/8JAvM=";
  };

  cargoHash = "sha256-HiZt3AxFMqIpRkg0TFpm8GDFCX6zYWTllO+xtVj7fjY=";
  cargoBuildFlags = [
    "--package"
    "shellcheck-sarif"
  ];
  cargoTestFlags = cargoBuildFlags;

  passthru = {
    tests.version = testers.testVersion { package = shellcheck-sarif; };
  };

  meta = {
    description = "CLI tool to convert shellcheck diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    mainProgram = "shellcheck-sarif";
    maintainers = with lib.maintainers; [ getchoo ];
    license = lib.licenses.mit;
  };
}
