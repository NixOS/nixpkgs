{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  types-pyopenssl,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-redis";
  version = "4.6.0.20240903";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S6saN42/I8LJXDcN/biajwM5V8T9GlP+5xtSnBgv4Ag=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    types-pyopenssl
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "redis-stubs" ];

  meta = with lib; {
    description = "Typing stubs for redis";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ gador ];
  };
}
