{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jupyterhub,
  ldap3,
  traitlets,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "jupyterhub-ldapauthenticator";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "ldapauthenticator";
    rev = "refs/tags/${version}";
    hash = "sha256-pb1d0dqu3VGCsuibpYgncbqCM9fz09yyoKGcKb14f4k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jupyterhub
    ldap3
    traitlets
  ];

  pythonImportsCheck = [ "ldapauthenticator" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # touch the socket
    "test_allow_config"
    "test_ldap_auth"
  ];

  meta = with lib; {
    description = "Simple LDAP Authenticator Plugin for JupyterHub";
    homepage = "https://github.com/jupyterhub/ldapauthenticator";
    changelog = "https://github.com/jupyterhub/ldapauthenticator/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
  };
}
