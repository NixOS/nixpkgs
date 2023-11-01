{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "numbat";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "numbat";
    rev = "v${version}";
    hash = "sha256-r6uPe2NL+6r/fKjf0C/5DLdB5YP3SIo8g8EsDxKP/3g=";
  };

  cargoHash = "sha256-MPqJjCfIwgK8QigWQYfWAYlg9RNMzF4x+0SprS0raKY=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "High precision scientific calculator with full support for physical units";
    longDescription = ''
      A statically typed programming language for scientific computations
      with first class support for physical dimensions and units
    '';
    homepage = "https://numbat.dev";
    changelog = "https://github.com/sharkdp/numbat/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    mainProgram = "numbat";
    maintainers = with maintainers; [ giomf ];
  };
}
