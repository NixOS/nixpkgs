{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "pybugz";
  version = "0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "williamh";
    repo = "pybugz";
    tag = version;
    hash = "sha256-rhiCQPSh987QEM4aMd3R/7e6l+pm2eJDE7f5LckIuho=";
  };

  build-system = [ python3Packages.flit-core ];

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
