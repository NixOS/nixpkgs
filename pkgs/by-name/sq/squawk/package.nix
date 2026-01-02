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
rustPlatform.buildRustPackage rec {
  pname = "squawk";
  version = "2.34.0";

  src = fetchFromGitHub {
    owner = "sbdchd";
    repo = "squawk";
    tag = "v${version}";
    hash = "sha256-SdCtZ+A4MuHhTrL5v65uDb47FeIBaGweHRXhD9crx2k=";
  };

  cargoHash = "sha256-r12pNc7C4mNYzIaE/99jrWBQ/YPqR30k90TFx1hBGR4=";

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
    changelog = "https://github.com/sbdchd/squawk/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = [ ];
  };
}
