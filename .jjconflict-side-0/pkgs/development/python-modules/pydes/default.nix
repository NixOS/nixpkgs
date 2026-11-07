{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
}:

buildPythonPackage {
  pname = "pydes";
  version = "unstable-2019-01-08";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "twhiteman";
    repo = "pyDes";
    rev = "e988a5ffc9abb8010fc75dba54904d1c5dbe83db";
    hash = "sha256-nI9gQjkM+8Jitmmzf4VGnGFHTWLrm0oaWV+V6RdHLGo=";
  };

  checkPhase = ''
    ${python.interpreter} test_pydes.py
  '';

  pythonImportsCheck = [ "pyDes" ];

  meta = {
    description = "Pure python module which implements the DES and Triple-DES encryption algorithms";
    homepage = "https://github.com/twhiteman/pyDes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j0hax ];
  };
}
