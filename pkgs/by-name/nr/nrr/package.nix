{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, pkg-config
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "nrr";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${version}";
    hash = "sha256-4zQi7kQxcRXpYuSjolSZoDqX+CcGmq4dvChPlZZZVso=";
  };

  cargoHash = "sha256-XNnyEFEzKQ5N0xtskaUudcb2LtAiEsd6h3D/FdyIbHc=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.IOKit
    libiconv
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "Minimal, blazing fast Node.js script runner";
    maintainers = with maintainers; [ ryanccn ];
    license = licenses.gpl3Only;
    mainProgram = "nrr";
  };
}
