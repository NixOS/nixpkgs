{
  lib,
  python3,
  fetchFromGitHub,
}:
let
  version = "1.9.8";
in
python3.pkgs.buildPythonApplication rec {
  inherit version;
  pname = "pyflyby";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "pyflyby";
    rev = "refs/tags/${version}";
    hash = "sha256-lMOLdPirPrld/DfX7YPdFJ+4K451aATz4vql4z+lLO0=";
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
