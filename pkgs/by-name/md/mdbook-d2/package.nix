{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-d2";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "danieleades";
    repo = "mdbook-d2";
    rev = "v${version}";
    hash = "sha256-d3PKwvTpOpqp6J1i53T7FYSEGO+yuL+wtpAwNjrPZcQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nV0VBbAivS6Qj62H1Uk/alDEPnryRmEfY3LZIIvDEKE=";
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "D2 diagram generator plugin for MdBook";
    mainProgram = "mdbook-d2";
    homepage = "https://github.com/danieleades/mdbook-d2";
    changelog = "https://github.com/danieleades/mdbook-d2/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao matthiasbeyer ];
  };
}
