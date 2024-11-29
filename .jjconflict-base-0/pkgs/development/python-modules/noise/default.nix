{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "noise";
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V6J5dDZXQ5H/Y6ER6FLlOkFk7Nga0jY5ZBdDzRogm2U=";
  };

  build-system = [ setuptools ];

  # PyPI release don't contain tests
  doCheck = false;

  pythonImportsCheck = [ "noise" ];

  meta = with lib; {
    description = "Native-code and shader implementations of Perlin noise";
    homepage = "https://github.com/caseman/noise";
    license = licenses.mit;
    maintainers = [ ];
  };
}
