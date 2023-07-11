{ lib
, fetchFromGitHub
, git
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dbx";
  version = "0.8.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "databrickslabs";
    repo = "dbx";
    rev = "refs/tags/v${version}";
    hash = "sha256-dArR1z3wkGDd3Y1WHK0sLjhuaKHAcsx6cCH2rgVdUGs=";
  };

  pythonRelaxDeps = [
    "rich"
    "typer"
  ];

  pythonRemoveDeps = [
    "mlflow-skinny"
  ];

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

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
    tenacity
    typer
    watchdog
  ] ++ typer.optional-dependencies.all;

  passthru.optional-dependencies = with python3.pkgs; {
    aws = [
      boto3
    ];
    azure = [
      azure-storage-blob
      azure-identity
    ];
    gcp = [
      google-cloud-storage
    ];
  };

  nativeCheckInputs = [
    git
  ] ++ (with python3.pkgs; [
    pytest-asyncio
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ]);

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
    changelog = "https://github.com/databrickslabs/dbx/blob/v${version}/CHANGELOG.md";
    license = licenses.databricks-dbx;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
