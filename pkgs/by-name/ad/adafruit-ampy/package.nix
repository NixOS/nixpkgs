{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "adafruit-ampy";
  version = "1.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9Mujb1ZAlvKq/Rc/f7q7hFNlzDuz9Bw3VB7fmLWNOXY=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    python-dotenv
    pyserial
  ];

  # No tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/pycampers/ampy";
    license = lib.licenses.mit;
    description = "Utility to interact with a MicroPython board over a serial connection";
    maintainers = [ ];
    mainProgram = "ampy";
  };
})
