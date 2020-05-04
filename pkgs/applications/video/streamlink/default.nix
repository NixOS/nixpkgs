{ stdenv, pythonPackages, fetchFromGitHub, rtmpdump, ffmpeg }:

pythonPackages.buildPythonApplication rec {
  version = "1.4.1";
  pname = "streamlink";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = version;
    sha256 = "1q3h48qwf7vs2wnbkwv0xnm6s65mkcyqdz7z6z3vrsmif2sb19l2";
  };

  checkInputs = with pythonPackages; [ pytest mock requests-mock freezegun ];

  propagatedBuildInputs = (with pythonPackages; [ pycryptodome requests iso-639 iso3166 websocket_client isodate ]) ++ [ rtmpdump ffmpeg ];

  meta = with stdenv.lib; {
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
    maintainers = with maintainers; [ dezgeg zraexy enzime ];
  };
}
