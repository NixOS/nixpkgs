{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "adafruit-ampy";
  version = "1.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4cba36f564096f2aafd173f7fbabb845365cc3bb3f41c37541edf98b58d3976";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
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
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ampy";
  };
}
