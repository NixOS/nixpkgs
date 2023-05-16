{ lib
, buildPythonApplication
, fetchPypi
<<<<<<< HEAD
, iso8601
, progressbar2
, requests
=======
, requests
, twitch-python
, pytz
, python-dateutil
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonApplication rec {
  pname = "twitch-chat-downloader";
<<<<<<< HEAD
  version = "2.5.3";

  # NOTE: Using maintained fork because upstream has stopped working, and it has
  # not been updated in a while.
  # https://github.com/PetterKraabol/Twitch-Chat-Downloader/issues/142
  src = fetchPypi {
    inherit version;
    pname = "tdh-tcd";
    sha256 = "sha256-dvj0HoF/2n5aQGMOD8UYY4EZegQwThPy1XJFvXyRT4Q=";
  };

  propagatedBuildInputs = [
    iso8601
    progressbar2
    requests
  ];
=======
  version = "3.2.2";

  src = fetchPypi {
    inherit version;
    pname = "tcd";
    sha256 = "ee6a8e22c54ccfd29988554b13fe56b2a1bf524e110fa421d77e27baa8dcaa19";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pipenv==2022.4.30'," "" \
      --replace "setuptools==62.1." "setuptools" \
      --replace "requests==2.27.1" "requests" \
      --replace "twitch-python==0.0.20" "twitch-python" \
      --replace "pytz==2022.1" "pytz" \
      --replace "python-dateutil==2.8.2" "python-dateutil"
  '';

  propagatedBuildInputs = [ requests twitch-python pytz python-dateutil ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false; # no tests

  pythonImportsCheck = [ "tcd" ];

  meta = with lib; {
    description = "Twitch Chat Downloader";
<<<<<<< HEAD
    homepage = "https://github.com/TheDrHax/Twitch-Chat-Downloader";
=======
    homepage = "https://github.com/PetterKraabol/Twitch-Chat-Downloader";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
