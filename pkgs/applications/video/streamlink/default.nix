{ stdenv, pythonPackages, fetchFromGitHub, rtmpdump, ffmpeg }:

pythonPackages.buildPythonApplication rec {
  version = "0.10.0";
  name = "streamlink-${version}";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = "${version}";
    sha256 = "1p9gkwcvqlnv09ihqh71nh82nnmq9ybp1v8d8kd2vhkg1vm5ximn";
  };

  checkInputs = with pythonPackages; [ pytest mock requests-mock ];

  propagatedBuildInputs = (with pythonPackages; [ pycryptodome requests iso-639 iso3166 websocket_client ]) ++ [ rtmpdump ffmpeg ];

  meta = with stdenv.lib; {
    homepage = https://github.com/streamlink/streamlink;
    description = "CLI for extracting streams from various websites to video player of your choosing";
    longDescription = ''
      Streamlink is a CLI utility that pipes flash videos from online
      streaming services to a variety of video players such as VLC, or
      alternatively, a browser.

      Streamlink is a fork of the livestreamer project.
    '';
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dezgeg zraexy ];
  };
}
