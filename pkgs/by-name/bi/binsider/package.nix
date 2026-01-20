{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "binsider";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "binsider";
    rev = "v${version}";
    hash = "sha256-ZfLFZXLnH5nBg/5ufOfwMG8c8n+BDex3j7da+Hvh1fw=";
  };

  cargoHash = "sha256-HnJBeqZhzDT0XfZ5UDg+lWMaX8tP7Q4iXrAz84XM3QE=";

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
