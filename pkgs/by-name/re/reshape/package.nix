{
  lib,
  rustPlatform,
  fetchCrate,
  postgresqlTestHook,
  postgresql,
}:

rustPlatform.buildRustPackage rec {
  pname = "reshape";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-viS//3ZFqogI0BbZ0rypo5zpQUgqKiLgK585iw3BMgM=";
  };

  cargoHash = "sha256-NLVNOgwc3C1QgEfiNkxV+KslMQeYW4YPt5vFyS01/Kg=";

  nativeCheckInputs = [
    postgresqlTestHook
    postgresql
  ];

  dontUseCargoParallelTests = true;

  postgresqlTestSetupPost = ''
    export POSTGRES_CONNECTION_STRING="user=$PGUSER dbname=$PGDATABASE host=$PGHOST"
  '';

  postgresqlTestUserOptions = "LOGIN SUPERUSER";

  meta = {
    description = "Easy-to-use, zero-downtime schema migration tool for Postgres";
    mainProgram = "reshape";
    homepage = "https://github.com/fabianlindfors/reshape";
    changelog = "https://github.com/fabianlindfors/reshape/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilyakooo0 ];
  };
}
