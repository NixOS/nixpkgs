{ lib
, fetchFromGitHub
, rustPlatform
, clippy
, clippy-sarif
, testers
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "clippy-sarif";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "${pname}-v${version}";
    hash = "sha256-EzWzDeIeSJ11CVcVyAhMjYQJcKHnieRrFkULc5eXAno=";
  };

  cargoSha256 = "sha256-F3NrqkqLdvMRIuozCMMqwlrrf5QrnmcEhy4TGSzPhiU=";
  cargoBuildFlags = [ "--package" pname ];
  cargoTestFlags = cargoBuildFlags;

  passthru = {
    tests.version = testers.testVersion {
      package = clippy-sarif;
    };

    updateScript = nix-update-script {
      extraArgs = [ "--regex" "'${pname}-(.*)'" ];
    };
  };

  meta = with lib; {
    mainProgram = "clippy-sarif";
    description = "A CLI tool to convert clippy diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    maintainers = with maintainers; [ getchoo ];
    license = licenses.mit;
    inherit (clippy.meta) platforms;
  };
}
