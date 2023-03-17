{ lib, buildPythonPackage, fetchPypi, pytest-runner, pytest }:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pxzr8sfm2hc5s96m9k044i44nwkva70n0ypr6a35v73zn891cx5";
  };

  nativeCheckInputs = [ pytest-runner pytest ];

  meta = with lib; {
    homepage = "http://python-cerberus.org/";
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
  };
}
