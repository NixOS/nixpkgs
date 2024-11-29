{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  python,
  pytest-django,
  pytestCheckHook,
  djangorestframework,
  setuptools,
}:

buildPythonPackage rec {
  pname = "djangorestframework-jsonp";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpadilla";
    repo = "django-rest-framework-jsonp";
    rev = "refs/tags/${version}";
    hash = "sha256-4mIO69GhtvbQBtztHVQYIDDDSZpKg0g7BFNHEupiYTs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    djangorestframework
  ];

  checkInputs = [
    pytestCheckHook
    pytest-django
  ];

  # Test fail with Django >=4
  # https://github.com/jpadilla/django-rest-framework-jsonp/issues/14
  doCheck = false;

  checkPhase = ''
    runHook preCheck
    rm tests/test_renderers.py
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "rest_framework_jsonp" ];

  meta = {
    description = "JSONP support for Django REST Framework";
    homepage = "https://jpadilla.github.io/django-rest-framework-jsonp/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ];
  };
}
