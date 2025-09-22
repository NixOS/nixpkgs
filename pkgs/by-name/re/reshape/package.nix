{
  lib,
  rustPlatform,
  fetchCrate,
  postgresqlTestHook,
  postgresql,
}:

rustPlatform.buildRustPackage rec {
  pname = "reshape";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wv2gKyXCEH+tnZkUUAisMbuseth3dsFiJujH8VO1ii4=";
  };

  cargoHash = "sha256-lK54SEayI015f2AQ6h4zadgkECLp4jCeJO7enBG0LeM=";

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
