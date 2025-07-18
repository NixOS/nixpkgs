{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  iso8601,
  progressbar2,
  requests,
}:

buildPythonApplication rec {
  pname = "twitch-chat-downloader";
  version = "2.5.4";
  format = "setuptools";

  # NOTE: Using maintained fork because upstream has stopped working, and it has
  # not been updated in a while.
  # https://github.com/PetterKraabol/Twitch-Chat-Downloader/issues/142
  src = fetchFromGitHub {
    owner = "TheDrHax";
    repo = "twitch-chat-downloader";
    rev = version;
    hash = "sha256-mV60ygrtQa9ZkJ2CImhAV59ckCJ7vJSA9cWkYE2xo1M=";
  };

  postPatch = ''
    # Update client ID for Twitch changes
    # See: <https://github.com/TheDrHax/Twitch-Chat-Downloader/pull/16>
    substituteInPlace tcd/example.settings.json \
      --replace-fail jzkbprff40iqj646a697cyrvl0zt2m6 kd1unb4b3q4t58fwlpcbzcbnm76a8fp
  '';

  propagatedBuildInputs = [
    iso8601
    progressbar2
    requests
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "tcd" ];

  meta = with lib; {
    description = "Twitch Chat Downloader";
    mainProgram = "tcd";
    homepage = "https://github.com/TheDrHax/Twitch-Chat-Downloader";
    license = licenses.mit;
    maintainers = with maintainers; [ assistant ];
  };
}
