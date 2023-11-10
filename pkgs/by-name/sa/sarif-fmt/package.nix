{ lib
, fetchFromGitHub
, rustPlatform
, clippy
, sarif-fmt
, testers
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "sarif-fmt";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "${pname}-v${version}";
    hash = "sha256-EzWzDeIeSJ11CVcVyAhMjYQJcKHnieRrFkULc5eXAno=";
  };

  cargoSha256 = "sha256-dHOxVLXtnqSHMX5r1wFxqogDf9QdnOZOjTyYFahru34=";
  cargoBuildFlags = [ "--package" pname ];
  cargoTestFlags = cargoBuildFlags;

  nativeCheckInputs = [
    # test_clippy
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
    tests.version = testers.testVersion {
      package = sarif-fmt;
    };

    updateScript = nix-update-script {
      extraArgs = [ "--regex" "'${pname}-(.*)'" ];
    };
  };

  meta = with lib; {
    mainProgram = "sarif-fmt";
    description = "A CLI tool to pretty print SARIF diagnostics";
    homepage = "https://psastras.github.io/sarif-rs";
    maintainers = with maintainers; [ getchoo ];
    license = licenses.mit;
  };
}
