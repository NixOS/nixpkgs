{ lib, buildPythonPackage, python, pythonOlder, fetchFromGitHub
, django, django-crispy-forms, djangorestframework, mock, pytz }:

buildPythonPackage rec {
  pname = "django-filter";
  version = "2.1.0-pre";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "carltongibson";
    repo = pname;
    rev = "24adad8c48bc9e7c7539b6510ffde4ce4effdc29";
    sha256 = "0hv4w95jnlzp9vdximl6bb27fyi75001jhvsbs0ikkd8amq8iaj7";
  };

  checkInputs = [ django django-crispy-forms djangorestframework mock pytz ];

  checkPhase = "${python.interpreter} runtests.py";

  meta = with lib; {
    description = "A reusable Django application for allowing users to filter querysets dynamically.";
    homepage = https://github.com/carltongibson/django-filter;
    license = licenses.bsd3;
    maintainers = with maintainers; [ earvstedt ];
  };
}
