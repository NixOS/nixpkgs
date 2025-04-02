{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  postgresql,
}:
rustPlatform.buildRustPackage rec {
  pname = "postgres-lsp";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "postgres_lsp";
    tag = version;
    hash = "sha256-UXBxqhfg3zxG+U4XhKQWqhxnmndmiRiXb8SZ0OlpuYg=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-wV1zqaNlihrjS/R9q8b50g5gY6FxddGi62R91adivQE=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    postgresql
  ];

  env = {
    SQLX_OFFLINE = 1;

    # As specified in the upstream: https://github.com/supabase-community/postgres-language-server/blob/main/.github/workflows/release.yml
    RUSTFLAGS = "-C strip=symbols -C codegen-units=1";
    PGT_VERSION = version;
  };

  cargoBuildFlags = [ "-p=pgt_cli" ];
  cargoTestFlags = cargoBuildFlags;

  meta = {
    description = "Language Server for Postgres";
    homepage = "https://github.com/supabase/postgres_lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "postgrestools";
  };
}
