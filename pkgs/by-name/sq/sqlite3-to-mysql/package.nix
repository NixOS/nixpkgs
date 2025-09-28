{
  lib,
  fetchFromGitHub,
  python3Packages,
  nixosTests,
  testers,
  sqlite3-to-mysql,
  mysql80,
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlite3-to-mysql";
  version = "2.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "techouse";
    repo = "sqlite3-to-mysql";
    tag = "v${version}";
    hash = "sha256-2SoLiqOLuGcB4IV2CPud+mjc5s8mqobD72kkx0WCwVU=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    with python3Packages;
    [
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
      mysql80
      python-dateutil
    ]
    ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

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
}
