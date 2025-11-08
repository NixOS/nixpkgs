{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mlarchive2maildir";
  version = "0.0.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "02zjwa7zbcbqj76l0qmg7bbf3fqli60pl2apby3j4zwzcrrryczs";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    click
    click-log
    requests
    six
  ];

  pythonImportsCheck = [ "mlarchive2maildir" ];

  meta = with lib; {
    homepage = "https://github.com/flokli/mlarchive2maildir";
    description = "Imports mail from (pipermail) archives into a maildir";
    mainProgram = "mlarchive2maildir";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
