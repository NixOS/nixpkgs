{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-freezegun";
  version = "1.1.10";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "types-freezegun";
    inherit (finalAttrs) version;
    hash = "sha256-yzotLu6VDqy6rAZzq1BJmCM2XOuMZVursVRKQURkCew=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "freezegun-stubs" ];

  meta = {
    description = "Typing stubs for freezegun";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
})
