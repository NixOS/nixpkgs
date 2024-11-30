{
  fetchPypi,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mycli";
  version = "1.27.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0R2k5hRkAJbqgGZEPXWUb48oFxTKMKiQZckf3F+VC3I=";
  };

  pythonRelaxDeps = [
    "sqlparse"
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    with python3Packages;
    [
      cli-helpers
      click
      configobj
      cryptography
      paramiko
      prompt-toolkit
      pyaes
      pygments
      pymysql
      pyperclip
      sqlglot
      sqlparse
    ]
    ++ cli-helpers.optional-dependencies.styles;

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

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
