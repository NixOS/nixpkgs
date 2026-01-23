{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sphinx-lint";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "sphinx-lint";
    tag = "v${version}";
    hash = "sha256-Cg/14asXB1ivKSoGuLghne7kmQiXuimYTUqmdVqba6M=";
  };

  build-system = [
    python3.pkgs.hatch-vcs
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    polib
    regex
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-cov
  ];

  meta = {
    description = "Check for stylistic and formal issues in .rst and .py files included in the documentation";
    homepage = "https://github.com/sphinx-contrib/sphinx-lint";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "sphinx-lint";
  };
}
