{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  CoreServices ? darwin.apple_sdk.frameworks.CoreServices,
}:
let
  version = "0.6.7";
in
rustPlatform.buildRustPackage {
  pname = "mdbook-alerts";
  inherit version;

  src = fetchFromGitHub {
    owner = "lambdalisue";
    repo = "rs-mdbook-alerts";
    rev = "v${version}";
    hash = "sha256-H3xpaluEUYWuP+JR4Zx8zs/EqeEZPiBa2wcaAtPdvGY=";
  };

  cargoHash = "sha256-epnhKGvKN/iHcI77wEJlq7A5S2CkVRoPFTD+fGp1BH8=";

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
