{
  lib,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mycli";
  version = "2.20.0";
  pyproject = true;

  # test_ssh_tunnel.py binds to localhost to find a free port; the darwin
  # sandbox blocks loopback networking unless this is enabled
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "mycli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jbEbyY5N6IY344sLiY9cjhPbwzHtNUJK4+SXkXU2lqM=";
  };

  pythonRelaxDeps = [
    "pygments"
    "pymysql"
    "wcwidth"
    "sqlglot" # nixpkgs sqlglot is at 28.x, mycli requires ~=30.17
    "sqlglotc"
    "sqlparse"
    "click"
    "cryptography"
    "cli_helpers"
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies =
    with python3Packages;
    [
      cli-helpers
      click
      clickdc
      configobj
      cryptography
      jinja2
      keyring
      llm
      prompt-toolkit
      pycryptodomex
      pygments
      pymysql
      pyperclip
      rapidfuzz
      sqlglot
      sqlparse
      pyfzf
      wcwidth
    ]
    ++ cli-helpers.optional-dependencies.styles
    ++ [ yaspin ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pytest-random-order
  ]);

  disabledTestPaths = [
    # require optional polars dependency (not packaged)
    "test/pytests/test_polars_transform.py"
    "test/pytests/test_polars_completion.py"
  ];

  pytestFlags = [
    # environment-specific completion keyword differences
    "--deselect=test/pytests/test_smart_completion_public_schema_only.py::test_backticked_column_completion_three_character"
    "--deselect=test/pytests/test_smart_completion_public_schema_only.py::test_backticked_column_completion_two_character"
    "--deselect=test/pytests/test_naive_completion.py::test_function_name_completion"
    # bash completion harness is sensitive to the system bash version and
    # exercises only the static completion script, not the packaged code
    "--deselect=test/pytests/test_bash_completion.py::test_bash_completion_matches_mycli_completion_behavior"
  ];

  meta = {
    description = "Command-line interface for MySQL";
    mainProgram = "mycli";
    longDescription = ''
      Rich command-line interface for MySQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "http://mycli.net";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jojosch ];
  };
})
