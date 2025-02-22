{
  lib,
  fetchFromGitHub,
  git,
  python3,
  addBinToPathHook,
  writableTmpDirAsHomeHook,
}:
let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      pydantic = super.pydantic_1;

      # python-on-whales is the only aiohttp dependency that is incompatible with pydantic_1
      # Override aiohttp to remove this dependency
      aiohttp = super.aiohttp.overridePythonAttrs (old: {
        # Remove python-on-whales from nativeCheckInputs
        nativeCheckInputs = lib.filter (p: (p.pname or "") != "python-on-whales") old.nativeCheckInputs;

        disabledTestPaths = [
          # Requires python-on-whales
          "tests/autobahn/test_autobahn.py"
        ] ++ (old.disabledTestPaths or [ ]);
      });

      instructor = super.instructor.overridePythonAttrs (old: {
        pythonRelaxDeps = [ "pydantic" ] ++ (old.pythonRelaxDeps or [ ]);
        pythonRemoveDeps = [ "pydantic-core" ] ++ (old.pythonRelaxDeps or [ ]);
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "dbx";
  version = "0.8.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "databrickslabs";
    repo = "dbx";
    tag = "v${version}";
    hash = "sha256-DNVJcCDHyWCorTxNN6RR6TWNF2MrysXT44UbwegROTU=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "databricks-cli"
    "rich"
    "typer"
    "pydantic"
    "tenacity"
  ];

  pythonRemoveDeps = [ "mlflow-skinny" ];

  build-system = with python.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python.pkgs; [
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

  optional-dependencies = with python.pkgs; {
    aws = [ boto3 ];
    azure = [
      azure-storage-blob
      azure-identity
    ];
    gcp = [ google-cloud-storage ];
  };

  nativeCheckInputs =
    [
      git
      addBinToPathHook
      writableTmpDirAsHomeHook
    ]
    ++ (with python.pkgs; [
      pytest-asyncio
      pytest-mock
      pytest-timeout
      pytestCheckHook
    ]);

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

  meta = {
    description = "CLI tool for advanced Databricks jobs management";
    homepage = "https://github.com/databrickslabs/dbx";
    changelog = "https://github.com/databrickslabs/dbx/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.databricks-dbx;
    maintainers = with lib.maintainers; [ GuillaumeDesforges ];
  };
}
