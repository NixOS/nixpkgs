{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  django,
}:

buildPythonPackage rec {
  pname = "django-admin-sortable2";
  version = "2.2.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jrief";
    repo = "django-admin-sortable2";
    rev = "refs/tags/${version}";
    hash = "sha256-WaDcDQF3Iq/UBE/tIlQFQiav6l5k6n+hKEsrcHwn+eY=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  pythonImportsCheck = [ "adminsortable2" ];

  # Tests are very slow (end-to-end with playwright)
  doCheck = false;

  meta = {
    description = "Generic drag-and-drop ordering for objects in the Django admin interface";
    homepage = "https://github.com/jrief/django-admin-sortable2";
    changelog = "https://github.com/jrief/django-admin-sortable2/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
