{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "pipenv-poetry-migrate";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yhino";
    repo = "pipenv-poetry-migrate";
    tag = "v${version}";
    hash = "sha256-M31bOvKGUlkzfZRQAxTkxhX8m9cCzEvsNZdyIyipwGI=";
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
    changelog = "https://github.com/yhino/pipenv-poetry-migrate/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gador ];
  };
}
