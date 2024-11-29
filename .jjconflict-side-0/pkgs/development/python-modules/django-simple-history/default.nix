{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  hatch-vcs,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-simple-history";
  version = "3.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-simple-history";
    rev = "refs/tags/${version}";
    hash = "sha256-bPdMdtiEDRvRD00ZBwUQkeCDKCx2SW65+FsbuMwVdK0=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
    hatch-vcs
  ];

  dependencies = [ django ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "simple_history" ];

  meta = with lib; {
    description = "Module to store Django model state on every create/update/delete";
    homepage = "https://github.com/jazzband/django-simple-history/";
    changelog = "https://github.com/jazzband/django-simple-history/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
