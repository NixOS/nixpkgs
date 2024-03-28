{ lib
, fetchFromGitHub
, rustPlatform
, shellcheck-sarif
, testers
, nix-update-script
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

  cargoSha256 = "sha256-JuE/Z0qrS/3BRlb0jTGDfV0TYk74Q75X1wv/IERxqeQ=";
  cargoBuildFlags = [ "--package" pname ];
  cargoTestFlags = cargoBuildFlags;

  passthru = {
    tests.version = testers.testVersion {
      package = shellcheck-sarif;
    };

    updateScript = nix-update-script {
      extraArgs = [ "--regex" "'${pname}-(.*)'" ];
    };
  };

  meta = with lib; {
    mainProgram = "shellcheck-sarif";
    description = "A CLI tool to convert shellcheck diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    maintainers = with maintainers; [ getchoo ];
    license = licenses.mit;
  };
}
