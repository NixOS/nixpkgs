{
  lib,
  python3,
  fetchFromGitHub,
}:
let
  version = "1.9.11";
in
python3.pkgs.buildPythonApplication rec {
  inherit version;
  pname = "pyflyby";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "pyflyby";
    tag = version;
    hash = "sha256-BBFLkojG0MeJ8Bj8cc10x/rUITqb4/UbLB+FQIVpYrw=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    six
    toml
    isort
    black
    ipython
  ];

  pythonImportsCheck = [ "pyflyby" ];

  meta = {
    description = "Set of productivity tools for Python";
    homepage = "https://github.com/deshaw/pyflyby";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfvillablanca ];
    mainProgram = "py";
  };
}
