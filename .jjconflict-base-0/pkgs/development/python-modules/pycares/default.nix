{
  lib,
  aiodns,
  buildPythonPackage,
  c-ares,
  cffi,
  fetchPypi,
  idna,
  pythonOlder,
  tornado,
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "4.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AltsL/6k6fuPmglzgcL+yySv8j+9aQbnDaIuybpg4Z0=";
  };

  buildInputs = [ c-ares ];

  propagatedBuildInputs = [
    cffi
    idna
  ];

  propagatedNativeBuildInputs = [ cffi ];

  # Requires network access
  doCheck = false;

  passthru.tests = {
    inherit aiodns tornado;
  };

  pythonImportsCheck = [ "pycares" ];

  meta = with lib; {
    description = "Python interface for c-ares";
    homepage = "https://github.com/saghul/pycares";
    changelog = "https://github.com/saghul/pycares/releases/tag/pycares-${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
