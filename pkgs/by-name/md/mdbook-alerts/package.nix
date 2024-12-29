{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  CoreServices ? darwin.apple_sdk.frameworks.CoreServices,
}:
let
  version = "0.6.0";
in
rustPlatform.buildRustPackage {
  pname = "mdbook-alerts";
  inherit version;

  src = fetchFromGitHub {
    owner = "lambdalisue";
    repo = "rs-mdbook-alerts";
    rev = "v${version}";
    hash = "sha256-LKNEI4dPXQwa+7JqLXpFZeKaQSSS5DFdeGuxEGNgPCU=";
  };

  cargoHash = "sha256-oycBTCjC58cO9q+eeO1nFGZGKdp6Bilgs8aFHW/4gXs=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

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
