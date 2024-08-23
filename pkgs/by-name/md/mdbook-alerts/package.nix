{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  CoreServices ? darwin.apple_sdk.frameworks.CoreServices,
}:
let
  version = "0.6.3";
in
rustPlatform.buildRustPackage {
  pname = "mdbook-alerts";
  inherit version;

  src = fetchFromGitHub {
    owner = "lambdalisue";
    repo = "rs-mdbook-alerts";
    rev = "v${version}";
    hash = "sha256-MoaV/JRhWKYEzUkzxRTgYjqBw+gb2h+Bjb4mEvWEkp8=";
  };

  cargoHash = "sha256-tHRbeDSK4aULz69jy5MeU4rANVuO2q3GUhDvBA4iQCM=";

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
