{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3,
  pythonRelaxDepsHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "databricks-sql-cli";
  version = "0.1.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-gr7LJfnvIu2Jf1XgILqfZoi8CbXeQyq0g1wLEBa5TPM=";
  };

  patches = [
    # https://github.com/databricks/databricks-sql-cli/pull/38
    (fetchpatch {
      url = "https://github.com/databricks/databricks-sql-cli/commit/fc294e00819b6966f1605e5c1ce654473510aefe.patch";
      sha256 = "sha256-QVrb7mD0fVbHrbrDywI6tsFNYM19x74LY8rhqqC8szE=";
    })
  ];

  pythonRelaxDeps = [
    "pandas"
    "databricks-sql-connector"
    "sqlparse"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'python = ">=3.7.1,<4.0"' 'python = ">=3.8,<4.0"' \
  '';

  nativeBuildInputs =
    (with python3.pkgs; [
      poetry-core
    ])
    ++ [ pythonRelaxDepsHook ];

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
    homepage = "https://github.com/databricks/databricks-sql-cli";
    changelog = "https://github.com/databricks/databricks-sql-cli/releases/tag/v${version}";
    license = licenses.databricks;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
