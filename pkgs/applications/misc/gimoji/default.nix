{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "gimoji";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = version;
    hash = "sha256-PF7vjbmoNSBD9C6JOB1s5NHnBEkv1LD/3RZAB0/HFPc=";
  };

  cargoHash = "sha256-iJblgcwn9uCl2X0AjG+dlAwdwwyZ321LRBFjDCZOr/A=";

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
