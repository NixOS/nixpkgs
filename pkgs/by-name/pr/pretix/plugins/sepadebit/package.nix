{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pretix-plugin-build,
  setuptools,

  # dependencies
  django-localflavor,
  sepaxml,

  # tests
  django-scopes,
  pretix,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pretix-sepadebit";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-sepadebit";
    tag = "v${version}";
    hash = "sha256-o4HVPuSpYIFjxmYuL+IsJJDkv+4ARuvaDqPjxWxlhMg=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  dependencies = [
    django-localflavor
    sepaxml
  ];

  pythonImportsCheck = [
    "pretix_sepadebit"
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

  meta = with lib; {
    description = "Plugin to receive payments via SEPA direct debit";
    homepage = "https://github.com/pretix/pretix-sepadebit";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbenno ];
  };
}
