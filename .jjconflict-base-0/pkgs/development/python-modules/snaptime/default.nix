{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python-dateutil,
  pytz,
}:

buildPythonPackage rec {
  pname = "snaptime";
  version = "0.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4/HriQQ9WNMHIauYy2UCPxpMJ0DjsZdwQpixY8ktUIs=";
  };

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    python-dateutil
    pytz
  ];

  pythonImportsCheck = [ "snaptime" ];

  # no tests on Pypi, no tags on github
  doCheck = false;

  meta = with lib; {
    description = "Transform timestamps with a simple DSL";
    homepage = "https://github.com/zartstrom/snaptime";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
