{
  lib,
  stdenv,
  diesel-cli,
  fetchCrate,
  installShellFiles,
  libiconv,
  libmysqlclient,
  nix-update-script,
  openssl,
  pkg-config,
  postgresql,
  rustPlatform,
  sqlite,
  testers,
  zlib,
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
  version = "2.2.6";

  src = fetchCrate {
    inherit version;
    crateName = "diesel_cli";
    hash = "sha256-jKTQxlmpTlb0eITwNbnYfONknGhHsO/nzdup04ikEB0=";
  };

  cargoHash = "sha256-+QbCPHczxCkDOFo/PDFTK0xReCWoz8AiLNwXA3aG9N0=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [ openssl ]
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

  checkFlags = [
    # all of these require a live database to be running
    # `DATABASE_URL must be set in order to run tests: NotPresent`
    "--skip=infer_schema_internals::information_schema::tests::get_primary_keys_only_includes_primary_key"
    "--skip=infer_schema_internals::information_schema::tests::load_table_names_loads_from_custom_schema"
    "--skip=infer_schema_internals::information_schema::tests::load_table_names_loads_from_public_schema_if_none_given"
    "--skip=infer_schema_internals::information_schema::tests::load_table_names_output_is_ordered"
    "--skip=infer_schema_internals::information_schema::tests::skip_views"
    "--skip=infer_schema_internals::mysql::test::get_table_data_loads_column_information"
    "--skip=infer_schema_internals::mysql::test::gets_table_comment"
    "--skip=infer_schema_internals::pg::test::get_foreign_keys_loads_foreign_keys"
    "--skip=infer_schema_internals::pg::test::get_foreign_keys_loads_foreign_keys_with_same_name"
    "--skip=infer_schema_internals::pg::test::get_table_data_loads_column_information"
    "--skip=infer_schema_internals::pg::test::gets_table_comment"
  ];
  cargoCheckFeatures = buildFeatures;

  # Tests currently fail due to *many* duplicate definition errors
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Database tool for working with Rust projects that use Diesel";
    homepage = "https://diesel.rs";
    changelog = "https://github.com/diesel-rs/diesel/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "diesel";
  };
}
