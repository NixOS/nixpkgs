{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "gimoji";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = version;
    hash = "sha256-rXGnSXqKxxmC2V2qapWZb+TB89a854ZGq1kG/3JjlUg=";
  };

  cargoHash = "sha256-WYMqKwe78D00ZZ+uwV61keRBNiJQKNqlpQtteVR0bVA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  meta = with lib; {
    description = "Easily add emojis to your git commit messages";
    homepage = "https://github.com/zeenix/gimoji";
    license = licenses.mit;
    mainProgram = "gimoji";
    maintainers = with maintainers; [ a-kenji ];
  };
}
