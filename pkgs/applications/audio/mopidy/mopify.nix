<<<<<<< HEAD
{ lib, pythonPackages, fetchPypi, mopidy }:
=======
{ lib, pythonPackages, mopidy }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-Mopify";
  version = "1.6.1";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = pythonPackages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "93ad2b3d38b1450c8f2698bb908b0b077a96b3f64cdd6486519e518132e23a5c";
  };

  propagatedBuildInputs = with pythonPackages; [ mopidy configobj ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/dirkgroenen/mopidy-mopify";
    description = "A mopidy webclient based on the Spotify webbased interface";
    license = licenses.gpl3;
    maintainers = [ maintainers.Gonzih ];
  };
}
