{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pybugz";
  version = "0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "williamh";
    repo = "pybugz";
    tag = finalAttrs.version;
    hash = "sha256-NwIZYcm+9+wsToIHf1bHotZm5lA0y2OeTGSmREzj17s=";
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
})
