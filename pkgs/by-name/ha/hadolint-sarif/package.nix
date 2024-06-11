{
  lib,
  fetchFromGitHub,
  rustPlatform,
  hadolint-sarif,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "hadolint-sarif";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "hadolint-sarif-v${version}";
    hash = "sha256-EzWzDeIeSJ11CVcVyAhMjYQJcKHnieRrFkULc5eXAno=";
  };

  cargoHash = "sha256-AMRL1XANyze8bJe3fdgZvBnl/NyuWP13jixixqiPmiw=";
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
