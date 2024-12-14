{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "databricks-sql-cli";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-wmwXw1o+pRsRjA7ai9x5o1el7mNBqM6xlGrvw0IqfMo=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  pythonRelaxDeps = [
    "pandas"
    "databricks-sql-connector"
    "sqlparse"
    "numpy"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cli-helpers
    click
    configobj
    databricks-sql-connector
    pandas
    prompt-toolkit
    pygments
    sqlparse
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "CLI for querying Databricks SQL";
    mainProgram = "dbsqlcli";
    homepage = "https://github.com/databricks/databricks-sql-cli";
    changelog = "https://github.com/databricks/databricks-sql-cli/releases/tag/v${version}";
    license = licenses.databricks;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
