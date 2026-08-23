{
  fetchFromGitHub,
  lib,
  python3Packages,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sqlit-tui";
  version = "1.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Maxteabag";
    repo = "sqlit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LAWlUnRa+i+XQN8Sl7ri4i0UGjyqV7MTz1X+XgNDAcI=";
  };

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    docker
    duckdb
    keyring
    mysql-connector-python
    oracledb
    paramiko
    psycopg2
    pyodbc
    pyperclip
    pytz
    sqlparse
    sshtunnel
    textual
    textual-fastdatatable
  ];

  nativeCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pytest-asyncio
    pytestCheckHook
  ]);

  pythonImportsCheck = [ "sqlit" ];

  disabledTestPaths = [
    "tests/ui/" # UI tests fail in the sandbox
  ];

  disabledTests = [
    "test_installer_cancel_terminates_process" # timeout error
    "test_detect_strategy_pip_user_fallback" # AssertionError: assert 'externally-managed' == 'pip-user'
  ];

  meta = {
    description = "Lightweight TUI for SQL Server, PostgreSQL, MySQL, SQLite, and more";
    homepage = "https://github.com/Maxteabag/sqlit";
    changelog = "https://github.com/Maxteabag/sqlit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
    mainProgram = "sqlit";
  };
})
