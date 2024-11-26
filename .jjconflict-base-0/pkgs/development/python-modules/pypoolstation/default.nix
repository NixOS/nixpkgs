{
  lib,
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pypoolstation";
  version = "0.5.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E5/Z7TgIZlbIDB9I+DJI812ce8ctidDAXGCHBFzk7F8=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    importlib-metadata
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pypoolstation" ];

  meta = with lib; {
    description = "Python library to interact the the Poolstation platform";
    homepage = "https://github.com/cibernox/PyPoolstation";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
