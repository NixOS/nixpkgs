{ lib
, python3
, fetchFromGitHub
, poetry
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "shell-genie";
  version = "unstable-2023-01-27";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dylanjcastillo";
    repo = pname;
    rev = "d6da42a4426e6058a0b5ae07837d8c003cd1239e";
    hash = "sha256-MGhQaTcl3KjAJXorOmMRec07LxH02T81rNbV2mYEpRA=";
  };

  nativeBuildInputs = [
    poetry
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

  meta = with lib; {
    description = "Describe your shell commands in natural language";
    homepage = "https://github.com/dylanjcastillo/shell-genie";
    license = licenses.unfree;
    maintainers = with maintainers; [ onny ];
  };
}
