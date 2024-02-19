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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${version}";
    hash = "sha256-WrpyT5h+eoCu7cspf9KGaM0FgLmnBm8tOHIWbj8sYpo=";
  };

  cargoHash = "sha256-XTKaVHy7FWYgMq5gNCLF8kIjDDyiyZ+GPZYBMKtLrsI=";

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
