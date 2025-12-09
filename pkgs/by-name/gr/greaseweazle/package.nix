{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "greaseweazle";
  version = "1.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "keirf";
    repo = "greaseweazle";
    rev = "v${version}";
    hash = "sha256-Ki4OvtcFn5DH87OCWY7xN9fRhGxlzS9QIuQCJxPWJco=";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = with python3.pkgs; [
    crcmod
    bitarray
    pyserial
    requests
  ];

  pythonImportsCheck = [
    "greaseweazle"
  ];

  meta = {
    description = "Tools for accessing a floppy drive at the raw flux level";
    homepage = "https://github.com/keirf/greaseweazle";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "greaseweazle";
  };
}
