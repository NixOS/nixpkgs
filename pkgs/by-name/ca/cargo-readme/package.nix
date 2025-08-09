{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-readme";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "webern";
    repo = "cargo-readme";
    rev = "v${version}";
    sha256 = "sha256-FFWHADATEfvZvxGwdkj+eTVoq7pnPuoUAhMGTokUkMs=";
  };

  cargoHash = "sha256-24D+ZcMGZN175LZNcNW8F5IsStk4au4xB0ZFe95EjPk=";

  # disable doc tests
  cargoTestFlags = [
    "--bins"
    "--lib"
  ];

  meta = with lib; {
    description = "Generate README.md from docstrings";
    mainProgram = "cargo-readme";
    homepage = "https://github.com/livioribeiro/cargo-readme";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      baloo
      matthiasbeyer
    ];
  };
}
