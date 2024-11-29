{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "wavinsentio";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oko3Ivj95vajNWjQTQK18i5B/DIBngjw2HLlzYqLv2Y=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "wavinsentio" ];

  meta = with lib; {
    description = "Python module to interact with the Wavin Sentio underfloor heating system";
    homepage = "https://github.com/djerik/wavinsentio";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
