{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "binsider";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "binsider";
    rev = "v${version}";
    hash = "sha256-FNaYMp+vrFIziBzZ8//+ppq7kwRjBJypqsxg42XwdEs=";
  };

  cargoHash = "sha256-ZoZbhmUeC63IZ5kNuACfRaCsOicZNUAGYABSpCkUCXA=";

  buildNoDefaultFeatures = !stdenv.hostPlatform.isLinux;

  checkType = "debug";
  checkFlags = [
    "--skip=test_extract_strings"
    "--skip=test_init"
  ];

  meta = with lib; {
    description = "Analyzer of executables using a terminal user interface";
    homepage = "https://github.com/orhun/binsider";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ samueltardieu ];
    mainProgram = "binsider";
  };
}
