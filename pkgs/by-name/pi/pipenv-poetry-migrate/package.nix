{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "pipenv-poetry-migrate";
  version = "0.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "yhino";
    repo = "pipenv-poetry-migrate";
    tag = "v${version}";
    hash = "sha256-M31bOvKGUlkzfZRQAxTkxhX8m9cCzEvsNZdyIyipwGI=";
  };

  nativeBuildInputs = [ python3Packages.poetry-core ];

  propagatedBuildInputs = with python3Packages; [
    setuptools # for pkg_resources
    tomlkit
    typer
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  meta = with lib; {
    description = "This is simple migration script, migrate pipenv to poetry";
    mainProgram = "pipenv-poetry-migrate";
    homepage = "https://github.com/yhino/pipenv-poetry-migrate";
    changelog = "https://github.com/yhino/pipenv-poetry-migrate/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ gador ];
  };
}
