{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  numpy,
  setuptools,

  # dependencies
  scipy,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "quaternion";
  version = "2024.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moble";
    repo = "quaternion";
    tag = "v${version}";
    hash = "sha256-Le9i7oFPcBuZw/oNwCxz3svzKg9zREk4peIJadTiJ/M=";
  };

  build-system = [
    hatchling
    numpy
    setuptools
  ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "quaternion" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Package add built-in support for quaternions to numpy";
    homepage = "https://github.com/moble/quaternion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ocfox ];
  };
}
