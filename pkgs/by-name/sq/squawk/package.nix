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
<<<<<<< HEAD
  version = "2.32.0";
=======
  version = "2.26.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sbdchd";
    repo = "squawk";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-k1UvK8OTY0CEjVFJ761jb52j05r/rzUDd+Jca/tVX1g=";
  };

  cargoHash = "sha256-QEbBfy4QqKfWO3SDq35HlUvB8FIbXVByM2c0OphfEsk=";
=======
    hash = "sha256-X1vr2WAWkv9puO5CCM6TrFg/5H5buemcplvIeYtk6Qo=";
  };

  cargoHash = "sha256-eyQQ7bdbu/o5UQ7edjgs3ZLiya/q5c+jgLSWQfAs5ck=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libiconv
    openssl
  ];

<<<<<<< HEAD
  env = {
    OPENSSL_NO_VENDOR = 1;

    LIBPG_QUERY_PATH = libpg_query;
  };
=======
  OPENSSL_NO_VENDOR = 1;

  LIBPG_QUERY_PATH = libpg_query;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
