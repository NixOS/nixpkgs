{ lib, buildPythonPackage, fetchFromGitHub
, pytest, pytest-django, django }:

buildPythonPackage rec {
  pname = "django-crispy-forms";
  version = "2019.04.21";

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "django-crispy-forms";
    rev = "e25a5326697e5b545689b3a914e516404a6911bb";
    sha256 = "12zqa76q6i7j47aqvhilivpbdplgp9zw2q8zfcjzlgclrqafaj39";
  };

  # For reasons unknown, the source dir must contain a dash
  # for the tests to run successfully
  postUnpack = ''
    mv $sourceRoot source-
    export sourceRoot=source-
  '';

  checkInputs = [ pytest pytest-django django ];

  checkPhase = ''
    PYTHONPATH="$(pwd):$PYTHONPATH" \
    DJANGO_SETTINGS_MODULE=crispy_forms.tests.test_settings \
      pytest crispy_forms/tests
  '';

  meta = with lib; {
    description = "The best way to have DRY Django forms";
    homepage = https://github.com/maraujop/django-crispy-forms;
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
