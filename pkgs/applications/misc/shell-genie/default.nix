{ lib
, python3
, fetchPypi
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "shell-genie";
  version = "0.2.10";
  format = "pyproject";

  src = fetchPypi {
    pname = "shell_genie";
    inherit version;
    hash = "sha256-z7LiAq2jLzqjg4Q/r9o7M6VbedeT34NyPpgctfqBp+8=";
  };

  pythonRelaxDeps = [
    "typer"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    colorama
    openai
    pyperclip
    rich
    shellingham
    typer
  ] ++ typer.optional-dependencies.all;

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "shell_genie"
  ];

  meta = with lib; {
    description = "Describe your shell commands in natural language";
    homepage = "https://github.com/dylanjcastillo/shell-genie";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
