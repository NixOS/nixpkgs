{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
,
}:
rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "v${version}";
    hash = "sha256-7JXkyRhoSjGYhse+2/v3Ndogar10K4N3ZUZNGpMiQ/A=";
  };

  cargoHash = "sha256-wZcnaT8EjbdSX6Y/UNS7v9/hQ9ISxkyRwRqRotXPCWU=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
