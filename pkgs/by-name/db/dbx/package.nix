{
  lib,
  fetchFromGitHub,
  git,
  python3,
}:
let
  python = python3.override {
    self = python;
    packageOverrides = self: super: { pydantic = super.pydantic_1; };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "dbx";
  version = "0.8.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "databrickslabs";
    repo = "dbx";
    rev = "refs/tags/v${version}";
    hash = "sha256-5qjEABNTSUD9I2uAn49HQ4n+gbAcmfnqS4Z2M9MvFXQ=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "databricks-cli"
    "rich"
    "typer"
  ];

  pythonRemoveDeps = [ "mlflow-skinny" ];

  build-system = with python.pkgs; [ setuptools ];

  propagatedBuildInputs = with python.pkgs; [
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
  ];

  optional-dependencies = with python3.pkgs; {
    aws = [ boto3 ];
    azure = [
      azure-storage-blob
      azure-identity
    ];
    gcp = [ google-cloud-storage ];
  };

  nativeCheckInputs =
    [ git ]
    ++ (with python3.pkgs; [
      pytest-asyncio
      pytest-mock
      pytest-timeout
      pytestCheckHook
    ]);

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH="$PATH:$out/bin"
  '';

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    # Fails because of dbfs CLI wrong call
    "test_dbfs_unknown_user"
    "test_dbfs_no_root"
    # Requires pylint, prospector, pydocstyle
    "test_python_basic_sanity_check"
  ];

  disabledTestPaths = [
    "tests/unit/api/"
    "tests/unit/api/test_build.py"
    "tests/unit/api/test_destroyer.py"
    "tests/unit/api/test_jinja.py"
    "tests/unit/commands/test_configure.py"
    "tests/unit/commands/test_deploy_jinja_variables_file.py"
    "tests/unit/commands/test_deploy.py"
    "tests/unit/commands/test_destroy.py"
    "tests/unit/commands/test_execute.py"
    "tests/unit/commands/test_help.py"
    "tests/unit/commands/test_launch.py"
    "tests/unit/models/test_deployment.py"
    "tests/unit/models/test_destroyer.py"
    "tests/unit/models/test_task.py"
    "tests/unit/sync/test_commands.py"
    "tests/unit/utils/test_common.py"
  ];

  pythonImportsCheck = [ "dbx" ];

  meta = with lib; {
    description = "CLI tool for advanced Databricks jobs management";
    homepage = "https://github.com/databrickslabs/dbx";
    changelog = "https://github.com/databrickslabs/dbx/blob/v${version}/CHANGELOG.md";
    license = licenses.databricks-dbx;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
