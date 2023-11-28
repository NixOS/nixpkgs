{ lib
, buildPythonApplication
, fetchFromGitHub
, gitMinimal
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gitlint";
  version = "0.19.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jorisroovers";
    repo = "gitlint";
    rev = "refs/tags/v${version}";
    hash = "sha256-4SGkkC4LjZXTDXwK6jMOIKXR1qX76CasOwSqv8XUrjs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # Upstream splitted the project into gitlint and gitlint-core to
  # simplify the dependency handling
  sourceRoot = "${src.name}/gitlint-core";

  nativeBuildInputs = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    arrow
    click
    sh
  ];

  nativeCheckInputs = with python3.pkgs; [
    gitMinimal
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gitlint"
  ];

  meta = with lib; {
    description = "Linting for your git commit messages";
    homepage = "https://jorisroovers.com/gitlint/";
    changelog = "https://github.com/jorisroovers/gitlint/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 fab ];
    mainProgram = "gitlint";
  };
}
