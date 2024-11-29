{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  setuptools,
  docopt,
  dj-database-url,
  python,
  django-filer,
  six,
  django-app-helper,
}:

buildPythonPackage rec {
  pname = "django-app-helper";
  version = "3.3.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nephila";
    repo = "django-app-helper";
    rev = "refs/tags/${version}";
    hash = "sha256-4nFg8B1uxGJVY1jcGr0e2Oi14lqXcFOi0HJ+ogE2ikg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dj-database-url
    docopt
    six
  ];

  checkInputs = [ django-filer ];

  # Tests depend on django-filer, which depends on this package.
  # To avoid infinite recursion, we only enable tests when building passthru.tests.
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} helper.py
  '';

  pythonImportsCheck = [ "app_helper" ];

  passthru.tests = {
    runTests = django-app-helper.overrideAttrs (_: {
      doCheck = true;
    });
  };

  meta = {
    description = "Helper for Django applications development";
    homepage = "https://django-app-helper.readthedocs.io";
    changelog = "https://github.com/nephila/django-app-helper/releases/tag/${version}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.onny ];
  };
}
