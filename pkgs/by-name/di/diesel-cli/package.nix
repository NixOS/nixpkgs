{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  installShellFiles,
  darwin,
  libiconv,
  libmysqlclient,
  openssl,
  pkg-config,
  postgresql,
  sqlite,
  testers,
  zlib,
  diesel-cli,
  sqliteSupport ? true,
  postgresqlSupport ? true,
  mysqlSupport ? true,
}:
assert lib.assertMsg (lib.elem true [
  postgresqlSupport
  mysqlSupport
  sqliteSupport
]) "support for at least one database must be enabled";

rustPlatform.buildRustPackage rec {
  pname = "diesel-cli";
  version = "2.1.1";

  src = fetchCrate {
    inherit version;
    crateName = "diesel_cli";
    hash = "sha256-fpvC9C30DJy5ih+sFTTMoiykUHqG6OzDhF9jvix1Ctg=";
  };

  cargoHash = "sha256-nPmUCww8sOJwnG7+uIflLPgT87xPX0s7g0AcuDKhY2I=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security
    ++ lib.optional (stdenv.isDarwin && mysqlSupport) libiconv
    ++ lib.optional sqliteSupport sqlite
    ++ lib.optional postgresqlSupport postgresql
    ++ lib.optionals mysqlSupport [
      libmysqlclient
      zlib
    ];

  buildNoDefaultFeatures = true;
  buildFeatures =
    lib.optional sqliteSupport "sqlite"
    ++ lib.optional postgresqlSupport "postgres"
    ++ lib.optional mysqlSupport "mysql";
  cargoCheckFeatures = buildFeatures;

  postInstall = ''
    installShellCompletion --cmd diesel \
      --bash <($out/bin/diesel completions bash) \
      --fish <($out/bin/diesel completions fish) \
      --zsh <($out/bin/diesel completions zsh)
  '';

  # Fix the build with mariadb, which otherwise shows "error adding symbols:
  # DSO missing from command line" errors for libz and libssl.
  env.NIX_LDFLAGS = lib.optionalString mysqlSupport "-lz -lssl -lcrypto";

  passthru = {
    tests.version = testers.testVersion { package = diesel-cli; };
  };

  meta = {
    description = "Database tool for working with Rust projects that use Diesel";
    homepage = "https://github.com/diesel-rs/diesel/tree/master/diesel_cli";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "diesel";
  };
}
