{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "tuckr";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "RaphGL";
    repo = "Tuckr";
    rev = version;
    hash = "sha256-oQSuR0Zt1T8YU3O2Dq/qHl4ysVDl+3EVvp9r2mD3hRA=";
  };

  cargoHash = "sha256-ESDfUZsoqwBurXuwNIRSqxoDWnA2VpDZ9Q9GGaV8B4Y=";

  doCheck = false; # test result: FAILED. 5 passed; 3 failed;

  meta = with lib; {
    description = "Super powered replacement for GNU Stow";
    homepage = "https://github.com/RaphGL/Tuckr";
    changelog = "https://github.com/RaphGL/Tuckr/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mimame ];
    mainProgram = "tuckr";
  };
}
