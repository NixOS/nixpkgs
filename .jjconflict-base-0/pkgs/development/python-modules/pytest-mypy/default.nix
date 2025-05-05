{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  filelock,
  pytest,
  mypy,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-mypy";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_mypy";
    inherit version;
    hash = "sha256-P1/K/3XIDczGtoz17MKOG75x6VMJRp63oov0CM5VwHQ=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    attrs
    mypy
    filelock
  ];

  # does not contain tests
  doCheck = false;
  pythonImportsCheck = [ "pytest_mypy" ];

  meta = {
    description = "Mypy static type checker plugin for Pytest";
    homepage = "https://github.com/dbader/pytest-mypy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
