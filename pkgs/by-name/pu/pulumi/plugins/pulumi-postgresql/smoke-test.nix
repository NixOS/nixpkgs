{
  stdenvNoCC,
  writeTextDir,
  postgresqlTestHook,
  postgresql,
  pulumiTestHook,
  pulumi,
  pulumi-yaml,
  pulumi-postgresql,
}:
stdenvNoCC.mkDerivation {
  name = "pulumi-postgresql-smoke-test";

  src = writeTextDir "Pulumi.yaml" ''
    name: smoke-test
    runtime: yaml
    resources:
      smokeTestDatabase:
        type: postgresql:Database
        name: smoke_test_database
        properties:
          name: smoke_test_database
  '';

  dontBuild = true;
  doCheck = true;

  nativeCheckInputs = [
    postgresqlTestHook
    postgresql
    pulumiTestHook
    pulumi
    pulumi-yaml
    pulumi-postgresql
  ];

  postgresqlTestUserOptions = "LOGIN SUPERUSER";

  # Provider does not support Unix socket connections.
  # https://github.com/cyrilgdn/terraform-provider-postgresql/issues/127
  postgresqlEnableTCP = true;
  __darwinAllowLocalNetworking = true;

  # Temporary workaround to allow running postgresqlTestHook with Darwin sandbox
  # until https://github.com/NixOS/nixpkgs/pull/383377 is merged.
  sandboxProfile = ''
    (allow ipc-sysv-shm)
    (allow ipc-sysv-sem)
  '';

  env.PGSSLMODE = "disable";

  checkPhase = ''
    runHook preCheck
    PGHOST=localhost pulumi update --skip-preview
    psql --command= smoke_test_database
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    runHook postInstall
  '';
}
