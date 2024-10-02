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
  version = "0.3.0";
in
rustPlatform.buildRustPackage rec {
  pname = "schemamap";
  inherit version;

  src = fetchFromGitHub {
    owner = "schemamap";
    repo = "schemamap";
    rev = "v${version}";
    hash = "sha256-49i2zyOy/yngSgvKd66RsOhF6OlYfgDnEtPEbmhEcIo=";
  };

  sourceRoot = "${src.name}/rust";

  cargoHash = "sha256-ILgvS96D6yF4Teaa5on6jHZlVoxRLSk8A523PzH1b5Y=";

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
