{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,

  # tests
  addBinToPathHook,
  gitMinimal,
  versionCheckHook,
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
        ]
        ++ (old.disabledTestPaths or [ ]);
      });

      databricks-sdk = super.databricks-sdk.overridePythonAttrs (old: {
        # Tests require langchain-openai which is incompatible with pydantic_1
        doCheck = false;
      });

      versioningit = super.versioningit.overridePythonAttrs (old: {
        # Tests fail with pydantic_1
        # AttributeError: type object 'CaseDetails' has no attribute 'model_validate_...
        doCheck = false;
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

  postPatch = ''
    # Probably a typo
      substituteInPlace src/dbx/custom.py \
        --replace-fail "_make_rich_rext" "_make_rich_text"

    # dbx pins an old version of typer.
    # In newer versions of typer, `callback` does not accept the 'name' argument anymore.
    substituteInPlace src/dbx/cli.py \
      --replace-fail 'name="dbx",' ""

    # Fixes: TypeError: 'NoneType' object is not iterable
    substituteInPlace src/dbx/utils/common.py \
      --replace-fail \
        '[t.split("=") for t in multiple_argument]' \
        '[t.split("=") for t in multiple_argument] if multiple_argument else []'
  '';

  pythonRelaxDeps = [
    "cryptography"
    "databricks-cli"
    "pydantic"
    "rich"
    "tenacity"
    "typer"
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
    setuptools
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

  nativeCheckInputs = [
    addBinToPathHook
    gitMinimal
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ (with python.pkgs; [
    pytest-asyncio
    pytest-mock
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ]);
  versionCheckProgramArg = "--version";

  disabledTests = [
    # Fails because of dbfs CLI wrong call
    "test_dbfs_unknown_user"
    "test_dbfs_no_root"

    # Requires pylint, prospector, pydocstyle
    "test_python_basic_sanity_check"

    # FileNotFoundError: [Errno 2] No such file or directory: '/build/tmph3veuluv...
    "test_load_file"
    "test_storage_serde"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # ERROR fsevents:fsevents.py:310 Unhandled exception in FSEventsEmitter
    # SystemError: Cannot start fsevents stream. Use a kqueue or polling observer instead.
    "tests/unit/sync/test_event_handler.py"
  ];

  pythonImportsCheck = [ "dbx" ];

  meta = {
    description = "CLI tool for advanced Databricks jobs management";
    homepage = "https://github.com/databrickslabs/dbx";
    changelog = "https://github.com/databrickslabs/dbx/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.databricks-dbx;
    maintainers = with lib.maintainers; [ ];
  };
}
