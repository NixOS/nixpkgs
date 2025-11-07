{
  lib,
  buildPythonPackage,
  fetchPypi,
  ldap3,
  ldaptor,
  matrix-synapse-unwrapped,
  pytestCheckHook,
  service-identity,
  setuptools,
  twisted,
}:

buildPythonPackage rec {
  pname = "matrix-synapse-ldap3";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i7ZRcXMWTUucxE9J3kEdjOvbLnBdXdHqHzhzPEoAnh0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    service-identity
    ldap3
    twisted
  ];

  nativeCheckInputs = [
    ldaptor
    matrix-synapse-unwrapped
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ldap_auth_provider" ];

  meta = with lib; {
    description = "LDAP3 auth provider for Synapse";
    homepage = "https://github.com/matrix-org/matrix-synapse-ldap3";
    license = licenses.asl20;
    teams = [ teams.c3d2 ];
  };
}
