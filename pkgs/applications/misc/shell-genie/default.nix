{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "shell-genie";
<<<<<<< HEAD
  version = "0.2.10";
=======
  version = "0.2.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    pname = "shell_genie";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-z7LiAq2jLzqjg4Q/r9o7M6VbedeT34NyPpgctfqBp+8=";
  };

  pythonRelaxDeps = [
    "typer"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
=======
    hash = "sha256-6miqTjiGLK7r6evfchwuAXTHj+JwoH/CqgRoa5+jDJI=";
  };

  nativeBuildInputs = [
    poetry-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
