<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, mopidy }:
=======
{ lib, python3Packages, mopidy }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "mopidy-mpris";
  version = "3.0.3";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit version;
    pname = "Mopidy-MPRIS";
    sha256 = "sha256-rHQgNIyludTEL7RDC8dIpyGTMOt1Tazn6i/orKlSP4U=";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.pydbus
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for controlling Mopidy through D-Bus using the MPRIS specification";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}

