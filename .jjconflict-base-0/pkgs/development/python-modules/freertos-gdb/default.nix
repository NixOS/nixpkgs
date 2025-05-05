{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "freertos-gdb";
  version = "1.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lH/dlTX2PuZ89rX5zzpedHkqHvdVy+h6BzJ8rVFmkb8=";
  };

  build-system = [
    setuptools
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "User-friendly view of FreeRTOS kernel objects in GDB";
    homepage = "https://github.com/espressif/freertos-gdb";
    license = licenses.asl20;
    maintainers = with maintainers; [
      danc86
    ];
  };
}
