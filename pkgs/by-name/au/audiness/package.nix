{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "audiness";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "audiusGmbH";
    repo = "audiness";
    rev = "refs/tags/${version}";
    hash = "sha256-PkzYsfEhwrMoB+a2eJMmt/PRCbjASQRm38reA8PP4aI=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pytenable
    typer
    validators
  ] ++ typer.optional-dependencies.all;

  pythonImportsCheck = [
    "audiness"
  ];

  meta = with lib; {
    description = "CLI tool to interact with Nessus";
    homepage = "https://github.com/audiusGmbH/audiness";
    changelog = "https://github.com/audiusGmbH/audiness/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "audiness";
  };
}
