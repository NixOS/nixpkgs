{
  lib,
  buildPythonPackage,
  fetchPypi,
  ldap3,
  ldaptor,
  matrix-synapse-unwrapped,
  packaging,
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

  patches = [
    # https://github.com/matrix-org/matrix-synapse-ldap3/pull/200
    ./setuptools-pkg_resources.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    service-identity
    ldap3
    packaging
    twisted
  ];

  nativeCheckInputs = [
    ldaptor
    matrix-synapse-unwrapped
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ldap_auth_provider" ];

  meta = {
    description = "LDAP3 auth provider for Synapse";
    homepage = "https://github.com/matrix-org/matrix-synapse-ldap3";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
