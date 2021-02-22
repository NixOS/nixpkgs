{ lib
, pythonPackages
, fetchFromGitHub
, rtmpdump
, ffmpeg_3
}:

pythonPackages.buildPythonApplication rec {
  pname = "streamlink";
  version = "2.0.0";
  disabled = pythonPackages.pythonOlder "3.5.0";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = version;
    sha256 = "+W9Nu5Ze08r7IlUZOkkVOz582E1Bbj0a3qIQHwxSmj8=";
  };

  checkInputs = with pythonPackages; [
    pytest
    mock
    requests-mock
    freezegun
  ];

  propagatedBuildInputs = (with pythonPackages; [
    pycryptodome
    requests
    iso-639
    iso3166
    websocket_client
    isodate
  ]) ++ [
    rtmpdump
    ffmpeg_3
  ];

  meta = with lib; {
    homepage = "https://github.com/streamlink/streamlink";
    description = "CLI for extracting streams from various websites to video player of your choosing";
    longDescription = ''
      Streamlink is a CLI utility that pipes flash videos from online
      streaming services to a variety of video players such as VLC, or
      alternatively, a browser.

      Streamlink is a fork of the livestreamer project.
    '';
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ dezgeg zraexy ];
  };
}
