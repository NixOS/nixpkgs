{
  fetchFromGitHub,
  lib,
  libiconv,
  libpg_query,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "squawk";
  version = "2.62.0";

  src = fetchFromGitHub {
    owner = "sbdchd";
    repo = "squawk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XazgQu5Ot1Vknn+tN9qWLfNlRefoA6yXerjrF0H/Mso=";
  };

  cargoHash = "sha256-Z8VNk8ZN0e7UOOTNAz0p8bt5a3F9g4IGi7l7t7+rZ/Q=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libiconv
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;

    LIBPG_QUERY_PATH = libpg_query;
  };

  checkFlags = [
    # depends on the PostgreSQL version
    "--skip=parse::tests::test_parse_sql_query_json"
  ];

  cargoBuildFlags = [
    "-p squawk"
  ];

  meta = {
    description = "Linter for PostgreSQL, focused on migrations";
    homepage = "https://squawkhq.com";
    changelog = "https://github.com/sbdchd/squawk/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.dibenzepin ];
  };
})
