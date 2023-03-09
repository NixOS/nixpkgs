{ lib
, python3
, fetchFromGitHub
, poetry
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "shell-genie";
  version = "0.2.6";
  format = "pyproject";

  src = fetchPypi {
    pname = "shell_genie";
    inherit version;
    hash = "sha256-MgQFHsBXrihfWBB/cz45ITf8oJG2gSenf1wzdbrAbjw=";
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
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "shell_genie"
  ];

  meta = with lib; {
    description = "Describe your shell commands in natural language";
    homepage = "https://github.com/dylanjcastillo/shell-genie";
    # https://github.com/dylanjcastillo/shell-genie/issues/3
    license = licenses.unfree;
    maintainers = with maintainers; [ onny ];
  };
}
