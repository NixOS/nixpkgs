{
  lib,
  fetchFromGitHub,
  rustPlatform,
  shellcheck-sarif,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "shellcheck-sarif";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "${pname}-v${version}";
    hash = "sha256-EzWzDeIeSJ11CVcVyAhMjYQJcKHnieRrFkULc5eXAno=";
  };

  cargoHash = "sha256-JuE/Z0qrS/3BRlb0jTGDfV0TYk74Q75X1wv/IERxqeQ=";
  cargoBuildFlags = [
    "--package"
    pname
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
