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
  version = "0.4.0";
in
rustPlatform.buildRustPackage rec {
  pname = "schemamap";
  inherit version;

  src = fetchFromGitHub {
    owner = "schemamap";
    repo = "schemamap";
    rev = "v${version}";
    hash = "sha256-L5p7Kh5sQAlDHrXgWUuiYZb3sV0Mp2ODEOMQsaB0iMs=";
  };

  sourceRoot = "${src.name}/rust";

  cargoHash = "sha256-rwAujQC/zV5nH5YQdjPRyf1L7SYSbdS3FJ5SAVMlhRE=";

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
