{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-synapse-ldap3";
    tag = "v${version}";
    hash = "sha256-d3TRtPEhyc45dj7k2TpJlBn8fZgKFDZxocKdfAoeI2w=";
  };

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
