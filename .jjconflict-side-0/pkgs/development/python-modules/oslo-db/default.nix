{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiosqlite,
  alembic,
  debtcollector,
  oslo-config,
  oslo-context,
  oslo-i18n,
  oslo-utils,
  oslotest,
  pbr,
  psycopg2,
  setuptools,
  sqlalchemy,
  stevedore,
  stestrCheckHook,
  testresources,
  testscenarios,
}:

buildPythonPackage (finalAttrs: {
  pname = "oslo-db";
  version = "18.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.db";
    tag = finalAttrs.version;
    hash = "sha256-YBF0JeaS65NWkvsM0K0WB3TtYqsHEwCbLyi29v6+WTI=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include oslo_db *" > MANIFEST.in
  '';

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    alembic
    debtcollector
    oslo-config
    oslo-i18n
    oslo-utils
    sqlalchemy
    stevedore
  ]
  ++ sqlalchemy.optional-dependencies.asyncio;

  nativeCheckInputs = [
    aiosqlite
    oslo-context
    oslotest
    stestrCheckHook
    psycopg2
    testresources
    testscenarios
  ];

  pythonImportsCheck = [
    "oslo_db"
    "oslo_db.sqlalchemy"
    "oslo_db.sqlalchemy.migration_cli"
  ];

  meta = {
    description = "Oslo Database library";
    homepage = "https://github.com/openstack/oslo.db";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
