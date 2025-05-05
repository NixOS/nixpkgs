{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-ujson";
  version = "5.10.0.20250326";
  pyproject = true;

  src = fetchPypi {
    pname = "types_ujson";
    inherit version;
    hash = "sha256-VGngXywx7LPEwCZ8yP5BvNEWgm+7Te1pgBpkXGh90BQ=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ujson-stubs" ];

  meta = with lib; {
    description = "Typing stubs for ujson";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ centromere ];
  };
}
