{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-i18n";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "kellpossible";
    repo = "cargo-i18n";
    rev = "v${version}";
    hash = "sha256-ck0GYy9DLngOunpItGQ4+qrlzaWDk0zTnIzuRQt2/Gw=";
  };

  cargoHash = "sha256-nvZx2wJDs7PZQLCl8Hrf2blR+lNUBVr6k664VSVQ5iI=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  cargoTestFlags = [ "--lib" ];

  meta = with lib; {
    description = "Rust Cargo sub-command and libraries to extract and build localization resources to embed in your application/library";
    homepage = "https://github.com/kellpossible/cargo-i18n";
    license = licenses.mit;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "cargo-i18n";
  };
}
