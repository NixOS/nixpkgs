{ lib
, fetchFromGitHub
, rustPlatform
, hadolint-sarif
, testers
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "hadolint-sarif";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "${pname}-v${version}";
    hash = "sha256-EzWzDeIeSJ11CVcVyAhMjYQJcKHnieRrFkULc5eXAno=";
  };

  cargoSha256 = "sha256-AMRL1XANyze8bJe3fdgZvBnl/NyuWP13jixixqiPmiw=";
  cargoBuildFlags = [ "--package" pname ];
  cargoTestFlags = cargoBuildFlags;

  passthru = {
    tests.version = testers.testVersion {
      package = hadolint-sarif;
    };

    updateScript = nix-update-script {
      extraArgs = [ "--regex" "'${pname}-(.*)'" ];
    };
  };

  meta = with lib; {
    mainProgram = "hadolint-sarif";
    description = "A CLI tool to convert hadolint diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    maintainers = with maintainers; [ getchoo ];
    license = licenses.mit;
  };
}
