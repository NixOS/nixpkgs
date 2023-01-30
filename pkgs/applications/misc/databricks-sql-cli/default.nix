{ lib
, buildPythonApplication
, fetchFromGitHub
, fetchpatch
, poetry-core
, pandas
, prompt-toolkit
, databricks-sql-connector
, pygments
, configobj
, sqlparse
, cli-helpers
, click
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "databricks-sql-cli";
  version = "0.1.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-cli";
    rev = "v${version}";
    sha256 = "sha256-gr7LJfnvIu2Jf1XgILqfZoi8CbXeQyq0g1wLEBa5TPM=";
  };

  patches = [
    # https://github.com/databricks/databricks-sql-cli/pull/38
    (fetchpatch {
      url = "https://github.com/databricks/databricks-sql-cli/commit/fc294e00819b6966f1605e5c1ce654473510aefe.patch";
      sha256 = "sha256-QVrb7mD0fVbHrbrDywI6tsFNYM19x74LY8rhqqC8szE=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'python = ">=3.7.1,<4.0"' 'python = ">=3.8,<4.0"' \
      --replace 'pandas = "1.3.4"' 'pandas = "~1.4"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    prompt-toolkit
    pandas
    databricks-sql-connector
    pygments
    configobj
    sqlparse
    cli-helpers
    click
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "CLI for querying Databricks SQL";
    homepage = "https://github.com/databricks/databricks-sql-cli";
    license = licenses.databricks;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
