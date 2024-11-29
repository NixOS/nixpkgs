{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "kitchen";
  version = "1.2.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uEz1gvG9FVa2DrxzcLnTMeuSR7awcM6J3+lZy6LAsDw=";
  };

  # Waiting for upstream's clean-up
  doCheck = false;

  pythonImportsCheck = [ "kitchen" ];

  meta = with lib; {
    description = "Kitchen contains a cornucopia of useful code";
    homepage = "https://github.com/fedora-infra/kitchen";
    changelog = "https://github.com/fedora-infra/kitchen/blob/${version}/NEWS.rst";
    license = licenses.lgpl2Only;
    maintainers = [ ];
  };
}
