{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "adafruit-ampy";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "f4cba36f564096f2aafd173f7fbabb845365cc3bb3f41c37541edf98b58d3976";
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
