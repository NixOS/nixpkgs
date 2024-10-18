{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  darwin,
}:

let
  version = "0.4.1";
in
rustPlatform.buildRustPackage rec {
  pname = "schemamap";
  inherit version;

  src = fetchFromGitHub {
    owner = "schemamap";
    repo = "schemamap";
    rev = "v${version}";
    hash = "sha256-+gNUJqAmPwiprxcen4QOTxBRikVONFJ43unE81ZDnSc=";
  };

  sourceRoot = "${src.name}/rust";

  cargoHash = "sha256-PNuAiu3fnkc7FE+GxUDwtUkxS+rK6cPLFuedRwxWhfA=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk;
      [
        frameworks.Security
        frameworks.CoreFoundation
        frameworks.CoreServices
        frameworks.SystemConfiguration
      ]
    );

  nativeBuildInputs = [ pkg-config ];

  meta = {
    changelog = "https://github.com/schemamap/schemamap/releases/tag/v${version}";
    description = "Instant batch data import for Postgres";
    homepage = "https://schemamap.io";
    license = lib.licenses.mit;
    mainProgram = "schemamap";
    maintainers = with lib.maintainers; [ thenonameguy ];
  };
}
