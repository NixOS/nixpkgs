{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  cython,
  oldest-supported-numpy,
  setuptools,

  # dependencies
  numpy,

  # checks
  colormath,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "color-operations";
  version = "0.1.4";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vincentsarago";
    repo = "color-operations";
    rev = "refs/tags/${version}";
    hash = "sha256-qqOTmVYD3VfjeVJtYvDQw+cxjcTsmqTYQNL1qMX+fL4=";
  };

  build-system = [
    cython
    oldest-supported-numpy
    setuptools
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    colormath
    pytestCheckHook
  ];

  preCheck = ''
    python setup.py build_ext --inplace
  '';

  pythonImportsCheck = [ "color_operations" ];

  meta = {
    description = "Apply basic color-oriented image operations. Fork of rio-color";
    homepage = "https://github.com/vincentsarago/color-operations";
    license = lib.licenses.mit;
    maintainers = lib.teams.geospatial.members;
  };
}
