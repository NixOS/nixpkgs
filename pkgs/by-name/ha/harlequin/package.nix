{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  glibcLocales,
  withPostgresAdapter ? true,
  withBigQueryAdapter ? true,
}:
python3Packages.buildPythonApplication rec {
  pname = "harlequin";
  version = "1.25.2-unstable-2024-12-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin";
    rev = "7ef5327157c7617c1032c9128b487b32d1c91fea";
    hash = "sha256-QoIjEfQgN6YWDDor4PxfeFkkFGAidUC0ZvHy+PqgnWs=";
  };

  pythonRelaxDeps = [
    "numpy"
    "pyarrow"
    "textual"
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

  nativeCheckInputs =
    [
      # FIX: restore on next release
      # versionCheckHook
    ]
    ++ (with python3Packages; [
      pytest-asyncio
      pytestCheckHook
    ]);

  disabledTests =
    [
      # Tests require network access
      "test_connect_extensions"
      "test_connect_prql"
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-darwin") [
      # Test incorrectly tries to load a dylib compiled for x86_64
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
