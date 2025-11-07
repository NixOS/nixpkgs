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
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-sepadebit";
    tag = "v${version}";
    hash = "sha256-Xnp7aic+Xf4wJzJbWqhsfMajT4AOQGQMIGIewJ5B37o=";
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

  disabledTests = [
    # https://github.com/pretix/pretix-sepadebit/issues/69
    "test_mail_context"
    "test_call_mail_context"
  ];

  meta = with lib; {
    description = "Plugin to receive payments via SEPA direct debit";
    homepage = "https://github.com/pretix/pretix-sepadebit";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbenno ];
  };
}
