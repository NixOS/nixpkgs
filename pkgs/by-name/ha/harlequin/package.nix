{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  glibcLocales,
  versionCheckHook,
  withPostgresAdapter ? true,
  withBigQueryAdapter ? true,
}:
python3Packages.buildPythonApplication rec {
  pname = "harlequin";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin";
    tag = "v${version}";
    hash = "sha256-IUzN+rWL69TUUS9npcmfSAPqy/8SYNusNAN/muCMqNI=";
  };

  pythonRelaxDeps = [
    "numpy"
    "pyarrow"
    "textual"
    "syrupy"
  ];

  build-system = with python3Packages; [ poetry-core ];

  nativeBuildInputs = [ glibcLocales ];

  dependencies =
    with python3Packages;
    [
      click
      duckdb
      importlib-metadata
      numpy
      packaging
      platformdirs
      questionary
      rich-click
      sqlfmt
      textual
      textual-fastdatatable
      textual-textarea
      tomlkit
    ]
    ++ lib.optionals withPostgresAdapter [ harlequin-postgres ]
    ++ lib.optionals withBigQueryAdapter [ harlequin-bigquery ];

  pythonImportsCheck = [
    "harlequin"
    "harlequin_duckdb"
    "harlequin_sqlite"
    "harlequin_vscode"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytestCheckHook
    versionCheckHook
  ];

  disabledTests =
    [
      # Tests require network access
      "test_connect_extensions"
      "test_connect_prql"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [
      # Test incorrectly tries to load a dylib/so compiled for x86_64
      "test_load_extension"
    ];

  disabledTestPaths = [
    # Tests requires more setup
    "tests/functional_tests/"
  ];

  meta = {
    description = "The SQL IDE for Your Terminal";
    homepage = "https://harlequin.sh";
    changelog = "https://github.com/tconbeer/harlequin/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "harlequin";
    maintainers = with lib.maintainers; [ pcboy ];
    platforms = lib.platforms.unix;
  };
}
