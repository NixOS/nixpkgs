{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  six,
  pycrypto,
}:

buildPythonPackage rec {
  pname = "libthumbor";
  version = "2.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1PsiFZrTDVQqy8A3nkaM5LdPiBoriRgHkklTOiczN+g=";
  };

  buildInputs = [ django ];

  propagatedBuildInputs = [
    six
    pycrypto
  ];

  doCheck = false;

  pythonImportsCheck = [ "libthumbor" ];

  meta = {
    description = "Python extension to thumbor";
    homepage = "https://github.com/heynemann/libthumbor";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
