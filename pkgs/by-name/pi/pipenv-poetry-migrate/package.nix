{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "pipenv-poetry-migrate";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yhino";
    repo = "pipenv-poetry-migrate";
    tag = "v${version}";
    hash = "sha256-iSBN8ZcQORxDao1JKX/cOStNAJ9P7tP/JshUeDrMwh4=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    setuptools # for pkg_resources
    tomlkit
    typer
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  meta = {
    description = "This is simple migration script, migrate pipenv to poetry";
    mainProgram = "pipenv-poetry-migrate";
    homepage = "https://github.com/yhino/pipenv-poetry-migrate";
    changelog = "https://github.com/yhino/pipenv-poetry-migrate/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gador ];
  };
}
