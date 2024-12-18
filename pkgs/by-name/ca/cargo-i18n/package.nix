{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-i18n";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "kellpossible";
    repo = "cargo-i18n";
    rev = "v${version}";
    hash = "sha256-azwQlXsoCgNB/TjSBBE+taUR1POBJXaPnS5Sr+HVR90=";
  };

  cargoHash = "sha256-vN62QmCuhu7AjL6xSpBU6/ul4WgNLZbjWDCFyHj6rIM=";

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
