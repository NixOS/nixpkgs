{
  lib,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlit-tui";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Maxteabag";
    repo = "sqlit";
    tag = "v${version}";
    hash = "sha256-O2/kbKXSjsdSrTFnnNwif2IfV0HG4IPYLrD1eznuhuo=";
  };

  build-system = with python3Packages; [
    hatchling
    uv-build
  ];

  dependencies = with python3Packages; [
    duckdb
    keyring
    mariadb
    mysql-connector
    oracledb
    paramiko
    psycopg2
    pyodbc
    pyperclip
    sshtunnel
    textual
  ];

  pythonRelaxDeps = [
    "paramiko"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "sqlit"
  ];

  disabledTests = [
    # UI tests fail in the sandbox
    "tests/ui/"
    "test_installer_cancel_terminates_process" # timeout error
  ];

  meta = {
    description = "Lightweight TUI for SQL Server, PostgreSQL, MySQL, SQLite, and more";
    homepage = "https://github.com/Maxteabag/sqlit";
    changelog = "https://github.com/Maxteabag/sqlit/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
    mainProgram = "sqlit";
  };
}
