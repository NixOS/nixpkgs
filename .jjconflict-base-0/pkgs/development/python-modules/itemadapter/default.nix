{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JlXIxQ8ahAXJ+nS4zcTaf+xUHKIXvIIbkKzIRRyYqdI=";
  };

  build-system = [ setuptools ];

  # Infinite recursion with Scrapy
  doCheck = false;

  pythonImportsCheck = [ "itemadapter" ];

  meta = with lib; {
    description = "Common interface for data container classes";
    homepage = "https://github.com/scrapy/itemadapter";
    changelog = "https://github.com/scrapy/itemadapter/raw/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
