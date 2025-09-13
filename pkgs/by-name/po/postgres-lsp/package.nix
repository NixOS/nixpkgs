{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "postgres-lsp";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "supabase-community";
    repo = "postgres-language-server";
    tag = finalAttrs.version;
    hash = "sha256-0Q8MxKeh12STWIJ9441uTz+qQXEJjCESj21C4X8CBC4=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-oIbS5BUpNOXwiRconqJI/jdXeX05FIZVNl2kYt+79wY=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    rust-jemalloc-sys
  ];

  env = {
    SQLX_OFFLINE = 1;

    # As specified in the upstream: https://github.com/supabase-community/postgres-language-server/blob/main/.github/workflows/release.yml
    RUSTFLAGS = "-C strip=symbols -C codegen-units=1";
    PGT_VERSION = finalAttrs.version;
  };

  cargoBuildFlags = [ "-p=pgt_cli" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;
  checkFlags = [
    # Tries to write to the file system relatively to the current path
    "--skip=syntax_error"
    # Requires a database connection
    "--skip=test_cli_check_command"
  ];

  meta = {
    description = "Tools and language server for Postgres";
    homepage = "https://pgtools.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      myypo
    ];
    mainProgram = "postgrestools";
  };
})
