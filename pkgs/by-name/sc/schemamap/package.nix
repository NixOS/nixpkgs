{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

let
  version = "0.4.3";
in
rustPlatform.buildRustPackage rec {
  pname = "schemamap";
  inherit version;

  src = fetchFromGitHub {
    owner = "schemamap";
    repo = "schemamap";
    rev = "v${version}";
    hash = "sha256-YR7Ucd8/Z1hOUNokmfSVP2ZxDL7qLb6SZ86/S7V/GKk=";
  };

  sourceRoot = "${src.name}/rust";

  cargoHash = "sha256-8UmLAT7Etb9MARoGhvOHPhkdR/8jCEAjAK/mWRHL9hk=";

  buildInputs = [ openssl ];

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
