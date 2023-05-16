<<<<<<< HEAD
{ lib, python3, fetchPypi }:
=======
{ lib, python3, notmuch }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3.pkgs.buildPythonApplication rec {
  pname = "mlarchive2maildir";
  version = "0.0.9";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
