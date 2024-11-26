{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygobject-stubs";
  version = "2.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pygobject-stubs";
    rev = "refs/tags/v${version}";
    hash = "sha256-Y9tqfv2DP2daxxafcQAtxH33pR3FHE8av0PkzEcs0RU=";
  };

  build-system = [ setuptools ];

  # This package does not include any tests.
  doCheck = false;

  meta = with lib; {
    description = "PEP 561 Typing Stubs for PyGObject";
    homepage = "https://github.com/pygobject/pygobject-stubs";
    changelog = "https://github.com/pygobject/pygobject-stubs/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hacker1024 ];
  };
}
