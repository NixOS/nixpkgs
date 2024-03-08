{ lib
, buildPythonApplication
, fetchPypi
, iso8601
, progressbar2
, requests
}:

buildPythonApplication rec {
  pname = "twitch-chat-downloader";
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

  doCheck = false; # no tests

  pythonImportsCheck = [ "tcd" ];

  meta = with lib; {
    description = "Twitch Chat Downloader";
    homepage = "https://github.com/TheDrHax/Twitch-Chat-Downloader";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
