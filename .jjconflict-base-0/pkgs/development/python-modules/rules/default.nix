{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  django,
  djangorestframework,
  python,
}:

buildPythonPackage rec {
  pname = "rules";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dfunckt";
    repo = "django-rules";
    rev = "refs/tags/v${version}";
    hash = "sha256-8Kay2b2uwaI/ml/cPpcj9svoDQI0ptV8tyGeZ76SgZw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "rules" ];

  nativeCheckInputs = [
    django
    djangorestframework
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/manage.py test testsuite -v2
    runHook postCheck
  '';

  meta = with lib; {
    description = "Awesome Django authorization, without the database";
    homepage = "https://github.com/dfunckt/django-rules";
    changelog = "https://github.com/dfunckt/django-rules/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
