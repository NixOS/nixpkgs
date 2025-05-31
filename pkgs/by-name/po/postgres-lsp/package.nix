{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "postgres-lsp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "supabase-community";
    repo = "postgres-language-server";
    tag = finalAttrs.version;
    hash = "sha256-78DUSoJwh310TAO0a8usa6+IwZhDdOCNys9fEAky3VY=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-IxVuxDauxH3AzXirJ3Zq8QLSdUL3H3j/oSGqfNs0J20=";

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
