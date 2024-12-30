{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "pybugz";
  version = "0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "williamh";
    repo = "pybugz";
    tag = version;
    hash = "sha256-n7fUs8/O+Kjzk40ZhZzpEitbod0bZpYFug0dkA8+gNs=";
  };

  build-system = [ python3Packages.setuptools ];

  pythonImportsCheck = [ "bugz" ];

  # no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/williamh/pybugz";
    description = "Command line interface for Bugzilla";
    mainProgram = "bugz";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}
