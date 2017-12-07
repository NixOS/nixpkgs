{ stdenv, pythonPackages, fetchFromGitHub, rtmpdump, ffmpeg }:

pythonPackages.buildPythonApplication rec {
  version = "0.8.1";
  name = "streamlink-${version}";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = "${version}";
    sha256 = "0l09vp108dw6d9d9rri2xwlr49mr5nkrlxbivr4kk5jbaczjp9xm";
  };

  buildInputs = with pythonPackages; [ pytest mock ];

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
