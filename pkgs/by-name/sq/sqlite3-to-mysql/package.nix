{
  lib,
  fetchFromGitHub,
  python3Packages,
  nixosTests,
  testers,
  sqlite3-to-mysql,
  mysql84,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sqlite3-to-mysql";
  version = "2.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "techouse";
    repo = "sqlite3-to-mysql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6WIGQVZZBWVGP8nr7Gxvd3j9wrt08EcCmb9ljRMkUgc=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    mysql-connector
    pytimeparse2
    pymysql
    pymysqlsa
    simplejson
    sqlalchemy
    sqlalchemy-utils
    tqdm
    tabulate
    unidecode
    packaging
    mysql84
    python-dateutil
    sqlglot
  ];

  pythonRelaxDeps = [
    "mysql-connector-python"
  ];

  # tests require a mysql server instance
  doCheck = false;

  # run package tests as a separate nixos test
  passthru.tests = {
    nixosTest = nixosTests.sqlite3-to-mysql;
    version = testers.testVersion {
      package = sqlite3-to-mysql;
      command = "sqlite3mysql --version";
    };
  };

  meta = {
    description = "Simple Python tool to transfer data from SQLite 3 to MySQL";
    homepage = "https://github.com/techouse/sqlite3-to-mysql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
    mainProgram = "sqlite3mysql";
  };
})
