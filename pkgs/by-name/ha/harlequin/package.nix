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
  version = "2.16.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0ZVqA7A8JWpUSx4uABWgaKtNlINwzY4Gld1z2cypJKc=";
  };

  postPatch =
    # The fake `ssh` client used by the ssh tests has a `/usr/bin/env` shebang
    ''
      patchShebangs tests/data/unit_tests/ssh/ssh
    '';

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [ glibcLocales ];

  pythonRelaxDeps = [
    "click"
    "questionary"
    "tomlkit"
    "wcwidth"
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

    # Flaky: both servers share the same `<name>.stderr` file, so the first
    # server's output can overwrite the second's "already running" message
    "test_a_second_server_under_the_same_name_is_refused"

    # Flaky: rely on sub-second/few-second timeouts, too tight on loaded builders
    "test_a_line_ssh_left_unfinished_is_still_shown"
    "test_a_session_that_has_been_up_long_enough_stops_itself"
    "test_a_session_waits_for_a_client_that_is_still_typing"
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

  __darwinAllowLocalNetworking = true;

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
