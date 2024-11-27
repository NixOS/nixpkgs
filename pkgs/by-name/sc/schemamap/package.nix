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

  cargoHash = "sha256-iq1/8oWVgiqdYfmJKzrIe9gkCz7fDw08QcaQgfd7vuo=";

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
