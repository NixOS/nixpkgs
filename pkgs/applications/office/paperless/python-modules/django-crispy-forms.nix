{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-django
, django
}:

buildPythonPackage rec {
  pname = "django-crispy-forms";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "django-crispy-forms";
    rev = version;
    sha256 = "0y6kskfxgckb9npcgwx4zrs5n9px159zh9zhinhxi3i7wlriqpf5";
  };

  # For reasons unknown, the source dir must contain a dash
  # for the tests to run successfully
  postUnpack = ''
    mv $sourceRoot source-
    export sourceRoot=source-
  '';

  checkInputs = [ django pytest-django pytestCheckHook ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=crispy_forms.tests.test_settings
  '';

  meta = with lib; {
    description = "The best way to have DRY Django forms";
    homepage = "https://github.com/maraujop/django-crispy-forms";
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
