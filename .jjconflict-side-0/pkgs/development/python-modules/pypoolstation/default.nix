{
  lib,
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypoolstation";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-wg7bFdK5FkTqKoGXRdBD9MKwLRm9mHvBVVne/CONb1k=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    backoff
    importlib-metadata
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pypoolstation" ];

  meta = {
    description = "Python library to interact with the Poolstation platform";
    homepage = "https://github.com/cibernox/PyPoolstation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
