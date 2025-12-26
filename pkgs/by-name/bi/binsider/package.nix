{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "binsider";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "binsider";
    rev = "v${version}";
    hash = "sha256-k40mnDRbvwWJmcT02aVWdwwEiDCuL4hQnvnPitrW8qA=";
  };

  cargoHash = "sha256-hysp7AeYJ153AC0ERcrRzf4ujmM+V9pgAxOvOlG/2aE=";

  buildNoDefaultFeatures = !stdenv.hostPlatform.isLinux;

  checkType = "debug";
  checkFlags = [
    "--skip=test_extract_strings"
    "--skip=test_init"
  ];

  meta = {
    description = "Analyzer of executables using a terminal user interface";
    homepage = "https://github.com/orhun/binsider";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ samueltardieu ];
    mainProgram = "binsider";
  };
}
