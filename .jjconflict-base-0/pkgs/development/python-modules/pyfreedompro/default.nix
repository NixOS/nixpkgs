{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "pyfreedompro";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "92812070a0c74761fa0c8cac98ddbe0bca781c8de80e2b08dbd04492e831c172";
  };

  propagatedBuildInputs = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiohttp" ];

  meta = with lib; {
    description = "Python library for Freedompro API";
    homepage = "https://github.com/stefano055415/pyfreedompro";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
