{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  CoreServices ? darwin.apple_sdk.frameworks.CoreServices,
}:
let
  version = "0.6.6";
in
rustPlatform.buildRustPackage {
  pname = "mdbook-alerts";
  inherit version;

  src = fetchFromGitHub {
    owner = "lambdalisue";
    repo = "rs-mdbook-alerts";
    rev = "v${version}";
    hash = "sha256-npPQU53l/VtTH23YYT6SOa11eUPNcA96al06S5HNNFE=";
  };

  cargoHash = "sha256-1wumxZoNr1QIit+KjgioG5WlSLSsWfcisChUEISoGQE=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  meta = {
    description = "Preprocessor for mdbook to support the inclusion of Markdown alerts";
    mainProgram = "mdbook-alerts";
    homepage = "https://github.com/lambdalisue/rs-mdbook-alerts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      brianmcgillion
      matthiasbeyer
    ];
  };
}
