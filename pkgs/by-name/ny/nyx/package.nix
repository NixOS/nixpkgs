{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "nyx";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "02rrlllz2ci6i6cs3iddyfns7ang9a54jrlygd2jw1f9s6418ll8";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ stem ];

  # ./run_tests.py returns `TypeError: testFailure() takes exactly 1 argument`
  doCheck = false;

  pythonImportsCheck = [ "nyx" ];

  meta = with lib; {
    description = "Command-line monitor for Tor";
    mainProgram = "nyx";
    homepage = "https://nyx.torproject.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ offline ];
  };
}
