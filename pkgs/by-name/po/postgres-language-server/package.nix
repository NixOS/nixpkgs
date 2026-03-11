{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rust-jemalloc-sys,
  tree-sitter,
  nodejs,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "postgres-language-server";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "supabase-community";
    repo = "postgres-language-server";
    tag = finalAttrs.version;
    hash = "sha256-E5HRNT4q0RJRJ5PW7uvvrni6jdBZYQCeEWgo0i/fmBQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-JRWe0D+H9MhVDva5rY8iRr/icLbVYGMjbwa3KSAori4=";

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
  # Many tests are integration tests requiring a running Postgres instance
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

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
