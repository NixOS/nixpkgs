<<<<<<< HEAD
{ lib, pythonPackages, fetchPypi, mopidy, glibcLocales }:
=======
{ lib, pythonPackages, mopidy, glibcLocales }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-Moped";
  version = "0.7.1";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = pythonPackages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "15461174037d87af93dd59a236d4275c5abf71cea0670ffff24a7d0399a8a2e4";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ mopidy ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/martijnboland/moped";
    description = "A web client for Mopidy";
    license = licenses.mit;
    maintainers = [];
    hydraPlatforms = [];
  };
}
