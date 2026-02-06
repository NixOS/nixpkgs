{
  lib,
  rustPlatform,
  fetchgit,
  rust-jemalloc-sys,
  tree-sitter,
  nodejs,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "postgres-language-server";
  version = "0.19.0";

  src = fetchgit {
    url = "https://github.com/supabase-community/postgres-language-server";
    tag = finalAttrs.version;
    hash = "sha256-0zmH9hYwmKYTRR1MxaHZcm7B2SzgCxYjLM4GCK61c7s=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-2PEyKjHWEkGEgRy0l6nIhARN0qoR4CIv/Qo+xHucgEc=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook

    # Required to build the custom tree-sitter grammar
    # https://github.com/supabase-community/postgres-language-server/blob/main/crates/pgls_treesitter_grammar/grammar.js
    tree-sitter
    nodejs
  ];

  buildInputs = [
    rust-jemalloc-sys
  ];

  env = {
    SQLX_OFFLINE = 1;

    # As specified in the upstream: https://github.com/supabase-community/postgres-language-server/blob/main/.github/workflows/release.yml
    RUSTFLAGS = "-C strip=symbols -C codegen-units=1";
    PGLS_VERSION = finalAttrs.version;
  };

  cargoBuildFlags = [ "-p=pgls_cli" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;
  checkFlags = [
    # Tries to write to the file system relatively to the current path
    "--skip=syntax_error"
    # Requires a database connection
    "--skip=test_cli_check_command"
    "--skip=dblint_detects_issues_snapshot"
    "--skip=dblint_empty_database_snapshot"
  ];

  meta = {
    description = "Tools and language server for Postgres";
    homepage = "https://pg-language-server.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      myypo
    ];
    mainProgram = "postgres-language-server";
  };
})
