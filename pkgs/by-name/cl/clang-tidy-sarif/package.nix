{ lib
, fetchFromGitHub
, rustPlatform
, clang-tidy-sarif
, testers
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "clang-tidy-sarif";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "psastras";
    repo = "sarif-rs";
    rev = "${pname}-v${version}";
    hash = "sha256-EzWzDeIeSJ11CVcVyAhMjYQJcKHnieRrFkULc5eXAno=";
  };

  cargoSha256 = "sha256-NzdgfHRDgLB6sMhBflk9rACEocLP23KlZL22iAfBfh8=";
  cargoBuildFlags = [ "--package" pname ];
  cargoTestFlags = cargoBuildFlags;

  passthru = {
    tests.version = testers.testVersion {
      package = clang-tidy-sarif;
    };

    updateScript = nix-update-script {
      extraArgs = [ "--regex" "'${pname}-(.*)'" ];
    };
  };

  meta = with lib; {
    mainProgram = "clang-tidy-sarif";
    description = "A CLI tool to convert clang-tidy diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    maintainers = with maintainers; [ getchoo ];
    license = licenses.mit;
  };
}
