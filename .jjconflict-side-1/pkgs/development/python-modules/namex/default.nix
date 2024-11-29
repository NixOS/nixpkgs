{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "namex";
  version = "0.0.8";
  pyproject = true;

  # Not using fetchFromGitHub because the repo does not have any tag/release.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MqUPbFZcC7EKp2KYyVlQer3A6FDv4IXcOPNED8s6qQs=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "namex" ];

  # This packages has no tests.
  doCheck = false;

  meta = {
    description = "Simple utility to separate the implementation of your Python package and its public API surface";
    homepage = "https://github.com/fchollet/namex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
