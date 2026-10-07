{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  requests,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybuildkite";
  version = "1.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pyasi";
    repo = "pybuildkite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yMUZUkERfxMUkVVYNkPiFf9wrZR6d5+gqW/P6ri2Q1I=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [ "pybuildkite" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Python library for the Buildkite API";
    homepage = "https://github.com/pyasi/pybuildkite";
    changelog = "https://github.com/pyasi/pybuildkite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
