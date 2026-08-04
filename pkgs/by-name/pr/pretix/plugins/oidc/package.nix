{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pretix-plugin-build,
  setuptools,

  # dependencies
  dictlib,
  oic,

  # tests
  django-scopes,
  pretix,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pretix-oidc";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thegcat";
    repo = "pretix-oidc";
    tag = "v${version}";
    hash = "sha256-qG2N9KGizAe8C1hQV1kgLAPhg64PgVNtiazeeOlPzCI=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  dependencies = [
    "dictlib"
    "oic"
  ];

  pythonImportsCheck = [
    "pretix_oidc"
  ];

  nativeCheckInputs = [
    django-scopes
    pretix
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=pretix.testutils.settings
  '';

  meta = {
    description = "OIDC authentication plugin for Pretix";
    homepage = "https://github.com/thegcat/pretix-oidc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbenno ];
  };
}
