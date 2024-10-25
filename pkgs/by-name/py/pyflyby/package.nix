{
  lib,
  python3,
  fetchFromGitHub,
}:
let
  version = "1.9.6";
in
python3.pkgs.buildPythonApplication rec {
  inherit version;
  pname = "pyflyby";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "pyflyby";
    rev = version;
    hash = "sha256-QkoFr9tFtZ+ZEWlxe9csrzoYFl9/V2l4hKYfUWsXUdc=";
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
