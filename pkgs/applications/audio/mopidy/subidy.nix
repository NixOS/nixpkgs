{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-subidy";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Prior99";
    repo = "mopidy-subidy";
    tag = finalAttrs.version;
    hash = "sha256-vx8swALENrWhxvzHwJCChpVsYlaJ0vrJ9WMXmSGErzA=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.py-sonic
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_subidy" ];

  meta = {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for playing music from a Subsonic-compatible Music Server";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wenngle ];
  };
})
