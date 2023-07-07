{ lib, fetchPypi, buildPythonApplication }:

buildPythonApplication rec {
  pname = "py65";
  version = "1.1.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "Q7rjiHJ/Ew985vut/8fVAf/wWYW5aBPSvNPm8A6g1zg=";
  };

  meta = with lib; {
    homepage = "https://py65.readthedocs.io/";
    description = "Emulate 6502-based microcomputer systems in Python";
    longDescription = ''
      Py65 includes a program called Py65Mon that functions as a machine
      language monitor. This kind of program is sometimes also called a
      debugger. Py65Mon provides a command line with many convenient commands
      for interacting with the simulated 6502-based system.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
