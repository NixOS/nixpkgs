<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, mopidy }:
=======
{ lib, python3Packages, mopidy }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Bandcamp";
  version = "1.1.5";
<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "sha256-wg9zcOKfZQRhpyA1Cu5wvdwKpmrlcr2m9mrqBHgUXAQ=";
  };

  propagatedBuildInputs = with python3Packages; [ mopidy pykka ];

  meta = with lib; {
    description = "Mopidy extension for playing music from bandcamp";
    homepage = "https://github.com/impliedchaos/mopidy-bandcamp";
    license = licenses.mit;
    maintainers = with maintainers; [ desttinghim ];
  };
}
