{
  lib,
  buildPythonPackage,
  fetchPypi,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "expiring-dict";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J3lC7cYNWxI0V8GkaGmMlJI9v6yNQLJjuSHATmlA3Ak=";
  };

  propagatedBuildInputs = [ sortedcontainers ];

  pythonImportsCheck = [ "expiring_dict" ];

  meta = with lib; {
    description = "Python dict with TTL support for auto-expiring caches";
    homepage = "https://github.com/dparker2/py-expiring-dict";
    license = licenses.mit;
    maintainers = [ ];
  };
}
