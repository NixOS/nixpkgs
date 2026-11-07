{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  chardet,
  requests,
}:

buildPythonPackage rec {
  pname = "baidu-aip";
  version = "4.16.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zNYjEVVwhqFAR7w7CR3rWYefUZcM+sPZ87KYfDDLxN0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    chardet
    requests
  ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "aip" ];

  meta = {
    description = "Baidu AI Platform SDK for Python";
    homepage = "https://github.com/Baidu-AIP/python-sdk";
    changelog = "https://github.com/Baidu-AIP/python-sdk/releases";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
