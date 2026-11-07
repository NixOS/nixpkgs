{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pyserial,
  pyyaml,
  pyftdi,
}:

buildPythonPackage {
  pname = "rcar-flash";
  version = "0.1.0-unstable-2025-07-18";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xen-troops";
    repo = "rcar_flash";
    rev = "f1de190c153926de67aced31884da13443737b88";
    hash = "sha256-qNRcMuxKNqzaARIXm3wz+GmwORTpxqeSTMBSp2JFJSU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyserial
    pyyaml
    pyftdi
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "rcar_flash" ];

  meta = {
    homepage = "https://github.com/xen-troops/rcar_flash";
    description = "Simple command line tool to automate writing IPLs (firmware) to Renesas RCAR-based boards";
    mainProgram = "rcar_flash";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zatm8 ];
  };
}
