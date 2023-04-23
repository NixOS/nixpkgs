{ lib
, python3
, fetchFromGitHub
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "shell-genie";
  version = "0.2.8";
  format = "pyproject";

  src = fetchPypi {
    pname = "shell_genie";
    inherit version;
    hash = "sha256-6miqTjiGLK7r6evfchwuAXTHj+JwoH/CqgRoa5+jDJI=";
  };

  nativeBuildInputs = [
    poetry-core
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
