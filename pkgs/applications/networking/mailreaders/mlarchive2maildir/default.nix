{ lib, python3, notmuch }:

python3.pkgs.buildPythonApplication rec {
  pname = "mlarchive2maildir";
  version = "0.0.9";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "02zjwa7zbcbqj76l0qmg7bbf3fqli60pl2apby3j4zwzcrrryczs";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools-scm ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    click
    click-log
    requests
    six
  ];

  meta = with lib; {
    homepage = "https://github.com/flokli/mlarchive2maildir";
    description = "Imports mail from (pipermail) archives into a maildir";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
