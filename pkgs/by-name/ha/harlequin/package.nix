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
let
  # Using textual 5.3.0 to avoid error at runtime
  # https://github.com/tconbeer/harlequin/issues/841
  python = python3Packages.python.override {
    self = python3Packages.python;
    packageOverrides = self: super: {
      textual = super.textual.overridePythonAttrs (old: rec {
        version = "5.3.0";

        src = fetchFromGitHub {
          owner = "Textualize";
          repo = "textual";
          tag = "v${version}";
          hash = "sha256-J7Sb4nv9wOl1JnR6Ky4XS9HZHABKtNKPB3uYfC/UGO4=";
        };
      });
    };
  };
  pythonPackages = python.pkgs;
in
pythonPackages.buildPythonApplication rec {
  pname = "harlequin";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin";
    tag = "v${version}";
    hash = "sha256-uHzhAI8ppp6aoveMPcLCQX2slhbor5Qy+IoTui+RP7M=";
  };

  pythonRelaxDeps = [
    "numpy"
    "pyarrow"
    "textual"
    "tree-sitter"
    "tree-sitter-sql"
    "rich-click"
  ];

  build-system = with pythonPackages; [ poetry-core ];

  nativeBuildInputs = [ glibcLocales ];

  dependencies =
    with pythonPackages;
    [
      click
      duckdb
      importlib-metadata
      numpy
      packaging
      platformdirs
      pyarrow
      questionary
      rich-click
      sqlfmt
      textual
      textual-fastdatatable
      textual-textarea
      tomlkit
      tree-sitter-sql
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

  nativeCheckInputs = with pythonPackages; [
    pytest-asyncio
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
    changelog = "https://github.com/tconbeer/harlequin/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "harlequin";
    maintainers = with lib.maintainers; [ pcboy ];
    platforms = lib.platforms.unix;
  };
}
