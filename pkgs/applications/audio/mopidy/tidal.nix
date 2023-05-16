{ lib
, python3Packages
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mopidy
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Tidal";
  version = "0.3.2";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    hash = "sha256-ekqhzKyU2WqTOeRR1ZSZA9yW3UXsLBsC2Bk6FZrQgmc=";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.tidalapi
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
  ];

  pytestFlagsArray = [ "tests/" ];

  meta = with lib; {
    description = "Mopidy extension for playing music from Tidal";
    homepage = "https://github.com/tehkillerbee/mopidy-tidal";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.rodrgz ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}


