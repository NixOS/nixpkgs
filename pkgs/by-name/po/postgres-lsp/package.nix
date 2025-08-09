{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "postgres-lsp";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "supabase-community";
    repo = "postgres-language-server";
    tag = finalAttrs.version;
    hash = "sha256-PL8irQ3R8m//BbtTjODBrBcG/bAdK+t6GZGAj0PkJwE=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-lUZpjX3HljOXi0Wt2xZCUru8uinWlngLEs5wlqfFiJA=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
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
  ];

  meta = {
    description = "Tools and language server for Postgres";
    homepage = "https://pgtools.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "postgrestools";
  };
})
