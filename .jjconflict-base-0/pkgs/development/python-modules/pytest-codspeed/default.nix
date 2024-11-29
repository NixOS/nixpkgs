{
  lib,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  filelock,
  hatchling,
  importlib-metadata,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-xdist,
  pytest,
  pytestCheckHook,
  rich,
  semver,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-codspeed";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "pytest-codspeed";
    rev = "refs/tags/v${version}";
    hash = "sha256-06U7S0hRb0J4hO48DaKMQk8Uzl2rUi1thQ4lGorfqpU=";
  };

  build-system = [ hatchling ];

  buildInput = [ pytest ];

  dependencies = [
    cffi
    filelock
    importlib-metadata
    rich
    setuptools
  ];

  optional-dependencies = {
    compat = [
      pytest-benchmark
      pytest-xdist
    ];
  };

  nativeCheckInputs = [
    semver
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_codspeed" ];

  meta = {
    description = "Pytest plugin to create CodSpeed benchmarks";
    homepage = "https://github.com/CodSpeedHQ/pytest-codspeed";
    changelog = "https://github.com/CodSpeedHQ/pytest-codspeed/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
