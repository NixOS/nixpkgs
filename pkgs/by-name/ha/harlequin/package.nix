{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  glibcLocales,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  withPostgresAdapter ? true,
  withBigQueryAdapter ? true,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "harlequin";
  version = "2.8.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gDK+QpAJzyjIBH1YcoYy7CXSy8yn0OxAc2V1jI/DAUs=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [ glibcLocales ];

  pythonRelaxDeps = [
    "questionary"
    "tomlkit"
  ];
  dependencies =
    with python3Packages;
    [
      click
      duckdb
      pandas
      platformdirs
      pyarrow
      pyperclip
      questionary
      rich-click
      sqlfmt
      textual
      textual-fastdatatable
      textual-textarea
      tomlkit
      wcwidth
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

  nativeCheckInputs = with python3Packages; [
    flaky
    pytest-asyncio
    pytest-textual-snapshot
    pytest-xdist
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
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
    description = "SQL IDE for Your Terminal";
    homepage = "https://harlequin.sh";
    changelog = "https://github.com/tconbeer/harlequin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "harlequin";
    maintainers = with lib.maintainers; [ pcboy ];
    platforms = lib.platforms.unix;
  };
})
