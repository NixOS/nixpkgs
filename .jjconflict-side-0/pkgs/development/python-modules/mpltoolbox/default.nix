{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  matplotlib,
  ipympl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mpltoolbox";
  version = "26.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "mpltoolbox";
    tag = version;
    hash = "sha256-vEnuTE+YZ8gK+desT4Bt5kqa2TSD0UkSSHKr7Kt8Xlo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    matplotlib
  ];

  nativeCheckInputs = [
    ipympl
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mpltoolbox"
  ];

  meta = {
    description = "Interactive tools for Matplotlib";
    homepage = "https://scipp.github.io/mpltoolbox/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
