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
  version = "2.70.0";

  src = fetchFromGitHub {
    owner = "sbdchd";
    repo = "squawk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D37eJT9A8hGi0E0kbjMjW9yitTbnHlKCE03y7p2A/us=";
  };

  cargoHash = "sha256-AIKjV9bBhdA7vsTD9wtVwcgAlcvhrM8J+tIKPr+sUZA=";

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
