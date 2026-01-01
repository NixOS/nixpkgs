{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "binsider";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "binsider";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-k40mnDRbvwWJmcT02aVWdwwEiDCuL4hQnvnPitrW8qA=";
  };

  cargoHash = "sha256-hysp7AeYJ153AC0ERcrRzf4ujmM+V9pgAxOvOlG/2aE=";
=======
    hash = "sha256-FNaYMp+vrFIziBzZ8//+ppq7kwRjBJypqsxg42XwdEs=";
  };

  cargoHash = "sha256-ZoZbhmUeC63IZ5kNuACfRaCsOicZNUAGYABSpCkUCXA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildNoDefaultFeatures = !stdenv.hostPlatform.isLinux;

  checkType = "debug";
  checkFlags = [
    "--skip=test_extract_strings"
    "--skip=test_init"
  ];

<<<<<<< HEAD
  meta = {
    description = "Analyzer of executables using a terminal user interface";
    homepage = "https://github.com/orhun/binsider";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ samueltardieu ];
=======
  meta = with lib; {
    description = "Analyzer of executables using a terminal user interface";
    homepage = "https://github.com/orhun/binsider";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ samueltardieu ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "binsider";
  };
}
