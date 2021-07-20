{ lib
, python3
, fetchFromGitHub
, rtmpdump
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "streamlink";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = version;
    sha256 = "1323v1pavmbb2vk3djdkxd8j6i3yrcgrkyl2d7xwkb7nwlla1x1v";
  };

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    mock
    requests-mock
    freezegun
  ];

  propagatedBuildInputs = (with python3.pkgs; [
    pycryptodome
    requests
    iso-639
    iso3166
    websocket-client
    isodate
  ]) ++ [
    rtmpdump
    ffmpeg
  ];

  disabledTests = [
    "test_plugin_not_in_removed_list"
  ];

  meta = with lib; {
    homepage = "https://github.com/streamlink/streamlink";
    description = "CLI for extracting streams from various websites to video player of your choosing";
    longDescription = ''
      Streamlink is a CLI utility that pipes videos from online
      streaming services to a variety of video players such as VLC, or
      alternatively, a browser.

      Streamlink is a fork of the livestreamer project.
    '';
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ dezgeg zraexy DeeUnderscore ];
  };
}
