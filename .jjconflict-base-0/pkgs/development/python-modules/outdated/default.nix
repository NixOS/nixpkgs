{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  littleutils,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "outdated";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "outdated";
    rev = "refs/tags/v${version}";
    hash = "sha256-5VpPmgIcVtY97F0Hb0m9MuSW0zjaUJ18ATA4GBRw+jc=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    littleutils
    requests
  ];

  # checks rely on internet connection
  doCheck = false;

  pythonImportsCheck = [ "outdated" ];

  meta = {
    description = "Mini-library which, given a package name and a version, checks if it's the latest version available on PyPI";
    homepage = "https://github.com/alexmojaki/outdated";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
}
