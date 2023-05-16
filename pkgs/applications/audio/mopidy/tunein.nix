<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, mopidy }:
=======
{ lib, python3Packages, mopidy }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "mopidy-tunein";
  version = "1.1.0";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit version;
    pname = "Mopidy-TuneIn";
    sha256 = "01y1asylscr73yqx071imhrzfzlg07wmqqzkdvpgm6r35marc2li";
  };

  propagatedBuildInputs = [
    mopidy
  ];

  pythonImportsCheck = [ "mopidy_tunein.tunein" ];

  meta = with lib; {
    description = "Mopidy extension for playing music from tunein";
    homepage = "https://github.com/kingosticks/mopidy-tunein";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
