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
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "sbdchd";
    repo = "squawk";
    tag = "v${version}";
    hash = "sha256-YNVxtfS2N6+ll8oxykVD3FCFJAdLksX5QJggMXi3G4s=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-nuAsZmaPCYvmKnJZsQzCVy/QNpY9ZQSAORL2U6NjsNY=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libiconv
    openssl
  ];

  OPENSSL_NO_VENDOR = 1;

  LIBPG_QUERY_PATH = libpg_query;

  checkFlags = [
    # depends on the PostgreSQL version
    "--skip=parse::tests::test_parse_sql_query_json"
  ];

  meta = {
    description = "Linter for PostgreSQL, focused on migrations";
    homepage = "https://squawkhq.com";
    changelog = "https://github.com/sbdchd/squawk/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ andrewsmith ];
  };
}
