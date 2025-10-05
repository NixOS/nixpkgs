{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.36";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SmbYNSB0eVUOWdDdPoMAPQTE7KeKTkklD4h+0t1LC/U=";
  };

  dependencies = with python3Packages; [
    pyserial
    pyudev
  ];

  meta = with lib; {
    homepage = "https://github.com/dhylands/rshell";
    description = "Remote Shell for MicroPython";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
