{
  lib,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "mycli";
  version = "1.43.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "mycli";
    tag = "v${version}";
    hash = "sha256-KybGpi9ZNkAiniZTnyzzjlUf+xISRk+k4kcIxU/iVSM=";
  };

  pythonRelaxDeps = [
    "sqlparse"
    "click"
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
      configobj
      cryptography
      llm
      paramiko
      prompt-toolkit
      pycryptodomex
      pygments
      pymysql
      pyperclip
      sqlglot
      sqlparse
      pyfzf
    ]
    ++ cli-helpers.optional-dependencies.styles;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ] ++ (with python3Packages; [ pytestCheckHook ]);

  disabledTestPaths = [
    "mycli/packages/paramiko_stub/__init__.py"
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
}
