{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rshell";
  version = "0.0.36";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-SmbYNSB0eVUOWdDdPoMAPQTE7KeKTkklD4h+0t1LC/U=";
  };

  dependencies = with python3Packages; [
    pyserial
    pyudev
  ];

  meta = {
    homepage = "https://github.com/dhylands/rshell";
    description = "Remote Shell for MicroPython";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ c0deaddict ];
  };
})
