{ lib, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-soundcloud";
<<<<<<< HEAD
  version = "3.0.2";
=======
  version = "3.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-soundcloud";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-1Qqbfw6NZ+2K1w+abMBfWo0RAmIRbNyIErEmalmWJ0s=";
  };

  propagatedBuildInputs = [
    mopidy
    pythonPackages.beautifulsoup4
  ];
=======
    sha256 = "18wiiv4rca9vibvnc27f3q4apf8n61kbp7mdbm2pmz86qwmd47pa";
  };

  propagatedBuildInputs = [ mopidy ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  meta = with lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ ];
  };
}
