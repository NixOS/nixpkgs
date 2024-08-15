{
  lib,
  darwin,
  fetchFromGitHub,
  gitUpdater,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "dbdev";
  version = "0.1.6";
  sourceRoot = "${src.name}/cli";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "dbdev";
    rev = "v${version}";
    hash = "sha256-G9U+dhSJI03n0lbBEVOrzslj8TlmiRwrg8DQ7hGsqIo=";
  };

  cargoHash = "sha256-v7QHUCKJjfTiG8ZylBmJ0rWRaeU9imGJBQhcESzZyUM=";

  nativeBuildInputs = [ pkg-config ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  strictDeps = true;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Database Package Registry for Postgres";
    mainProgram = "dbdev";
    homepage = "https://github.com/supabase/dbdev";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ david-r-cox ];
  };
}
