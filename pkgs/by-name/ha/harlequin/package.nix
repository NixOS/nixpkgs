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
  version = "2.12.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IJeJMIB1+8/1p+ZhUf/EHm+zwsB8n5YRIHfd+a/WjQk=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [ glibcLocales ];

  pythonRelaxDeps = [
    "click"
    "questionary"
    "tomlkit"
  ];
  dependencies =
    with python3Packages;
    [
      click
      duckdb
      msgspec
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
      tree-sitter
      tree-sitter-sql
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
    jsonschema
    pytest-asyncio
    pytest-textual-snapshot
    pytest-xdist
    pytestCheckHook
    pyyaml
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Compare the source checkout with the installed package
    #   AssertionError: assert PosixPath(...
    "test_a_release_bumps_the_version_and_rewrites_nothing_else"
    "test_the_marketplace_entry_names_a_source_that_exists"

    # KeyError: 'read_only'
    "test_saying_yes_writes_the_key"
    "test_the_prompt_offers_what_the_profile_already_says"

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

    # Compares the artifacts published to harlequin.sh with the source checkout
    "tests/unit_tests/test_publish_artifacts.py"
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
