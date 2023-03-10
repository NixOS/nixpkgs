{ lib
, buildPythonApplication
, fetchFromGitHub
, gitMinimal
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gitlint";
  version = "0.19.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jorisroovers";
    repo = "gitlint";
    rev = "v${version}";
    sha256 = "sha256-w4v6mcjCX0V3Mj1K23ErpXdyEKQcA4vykns7UwNBEZ4=";
  };

  patches = [
    # otherwise hatch tries to run git to collect some metadata about the build
    ./dont-try-to-use-git.diff
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # Upstream splitted the project into gitlint and gitlint-core to
  # simplify the dependency handling
  sourceRoot = "source/gitlint-core";

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
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 fab ];
  };
}
