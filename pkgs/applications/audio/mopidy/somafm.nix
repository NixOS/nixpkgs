<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, mopidy }:
=======
{ lib, python3Packages, mopidy }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "mopidy-somafm";
  version = "2.0.2";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit version;
    pname = "Mopidy-SomaFM";
    sha256 = "DC0emxkoWfjGHih2C8nINBFByf521Xf+3Ks4JRxNPLM=";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for playing music from SomaFM";
    license = licenses.mit;
    maintainers = [ maintainers.nickhu ];
  };
}

