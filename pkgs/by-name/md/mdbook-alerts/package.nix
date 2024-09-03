{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  CoreServices ? darwin.apple_sdk.frameworks.CoreServices,
}:
let
  version = "0.6.4";
in
rustPlatform.buildRustPackage {
  pname = "mdbook-alerts";
  inherit version;

  src = fetchFromGitHub {
    owner = "lambdalisue";
    repo = "rs-mdbook-alerts";
    rev = "v${version}";
    hash = "sha256-bg3X7M2H553tGxH8cEkkT0XK20fWwkp2nTVEgtZ819s=";
  };

  cargoHash = "sha256-MMhpH3WIAXnjw6xOl2HNfrIFEwjHfVDPquWnFhhZCMU=";

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
