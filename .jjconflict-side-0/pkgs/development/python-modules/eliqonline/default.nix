{
  lib,
  aiohttp,
  buildPythonPackage,
  docopt,
  fetchPypi,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "eliqonline";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "hOUN4cA4pKVioIrfJM02GOnZdDRc7xbNtvHfoD3//bM=";
  };

  propagatedBuildInputs = [
    aiohttp
    docopt
    pyyaml
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "eliqonline" ];

  meta = with lib; {
    description = "Python client to the Eliq Online API";
    mainProgram = "eliqonline";
    homepage = "https://github.com/molobrakos/eliqonline";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
