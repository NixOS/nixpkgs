{
  python3Packages,
  fetchFromGitHub,
  lib,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyflyby";
  version = "1.9.11";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "pyflyby";
    tag = finalAttrs.version;
    hash = "sha256-BBFLkojG0MeJ8Bj8cc10x/rUITqb4/UbLB+FQIVpYrw=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    black
    ipython
    isort
    six
    toml
  ];

  pythonImportsCheck = [ "pyflyby" ];

  meta = {
    description = "Set of productivity tools for Python";
    homepage = "https://github.com/deshaw/pyflyby";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfvillablanca ];
    mainProgram = "py";
  };
})
