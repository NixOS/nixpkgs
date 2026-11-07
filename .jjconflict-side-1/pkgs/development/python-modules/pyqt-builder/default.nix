{
  lib,
  buildPythonPackage,
  fetchPypi,
  packaging,
  setuptools,
  setuptools-scm,
  sip,
}:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.19.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pyqt_builder";
    inherit version;
    hash = "sha256-avZka6KWaHUbA5v9ztUWQstRDjAHlrWKTWi3+VagJNg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    sip
  ];

  pythonImportsCheck = [ "pyqtbuild" ];

  # There aren't tests
  doCheck = false;

  meta = {
    description = "PEP 517 compliant build system for PyQt";
    homepage = "https://github.com/Python-PyQt/PyQt-builder";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
