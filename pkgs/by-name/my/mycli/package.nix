{
  lib,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mycli";
  version = "1.72.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "mycli";
    tag = finalAttrs.version;
    hash = "sha256-1drwoKOSCcjbHEm7iqxuhQjb8fcZqvKCCwJ5FfyniD4=";
  };

  pythonRelaxDeps = [
    "pygments"
    "sqlglot" # nixpkgs sqlglot is at 28.x, mycli requires ~=30.7
    "sqlparse"
    "click"
    "cryptography"
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
      keyring
      llm
      paramiko
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
    ++ cli-helpers.optional-dependencies.styles;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pytest-random-order
  ]);

  disabledTestPaths = [
    "mycli/packages/paramiko_stub/__init__.py"
  ];

  pytestFlags = [
    # environment-specific completion keyword differences
    "--deselect=test/pytests/test_smart_completion_public_schema_only.py::test_backticked_column_completion_three_character"
    "--deselect=test/pytests/test_smart_completion_public_schema_only.py::test_backticked_column_completion_two_character"
    "--deselect=test/pytests/test_naive_completion.py::test_function_name_completion"
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
