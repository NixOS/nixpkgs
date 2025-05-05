{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # non-propagates
  django,

  # dependencies
  beautifulsoup4,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-bootstrap4";
  version = "25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap4";
    tag = "v${version}";
    hash = "sha256-WIz7T2f3xvsT2rSq1MUFwHpvzgHyLgTRpzb9z98sUmo=";
  };

  build-system = [ hatchling ];

  dependencies = [ beautifulsoup4 ];

  pythonImportsCheck = [ "bootstrap4" ];

  nativeCheckInputs = [
    (django.override { withGdal = true; })
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.app.settings
  '';

  meta = with lib; {
    description = "Bootstrap 4 integration with Django";
    homepage = "https://github.com/zostera/django-bootstrap4";
    changelog = "https://github.com/zostera/django-bootstrap4/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
