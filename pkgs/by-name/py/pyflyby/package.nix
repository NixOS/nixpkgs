{
  python3Packages,
  fetchFromGitHub,
  lib,
  pkg-config,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyflyby";
  version = "1.11.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "pyflyby";
    tag = finalAttrs.version;
    hash = "sha256-Jv3QVLJV7Uio674DRcB1sbDHsUy0y/MG7dd+L1gmFSc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  build-system = with python3Packages; [
    meson-python
    pybind11
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    black
    prompt-toolkit
    platformdirs
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
