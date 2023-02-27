{ lib
, fetchFromGitHub
, git
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dbx";
  version = "0.7.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "databrickslabs";
    repo = "dbx";
    rev = "v${version}";
    hash = "sha256-P/cniy0xYaDoUbKdvV7KCubCpmOAhYp3cg2VBRA+a6I=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    click
    cookiecutter
    cryptography
    databricks-cli
    jinja2
    mlflow
    pathspec
    pydantic
    pyyaml
    requests
    retry
    rich
    typer
    watchdog
  ] ++ typer.optional-dependencies.all;

  nativeCheckInputs = [
    git
  ] ++ (with python3.pkgs; [
    pytest-asyncio
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ]);

  postPatch = ''
    substituteInPlace setup.py \
      --replace "mlflow-skinny>=1.28.0,<=2.0.0" "mlflow" \
      --replace "rich==12.5.1" "rich"
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH="$PATH:$out/bin"
  '';

  pytestFlagsArray = [
    "tests/unit"
  ];

  disabledTests = [
    # Fails because of dbfs CLI wrong call
    "test_dbfs_unknown_user"
    "test_dbfs_no_root"
    # Requires pylint, prospector, pydocstyle
    "test_python_basic_sanity_check"
  ];

  pythonImportsCheck = [
    "dbx"
  ];

  meta = with lib; {
    description = "CLI tool for advanced Databricks jobs management";
    homepage = "https://github.com/databrickslabs/dbx";
    license = licenses.databricks-dbx;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
