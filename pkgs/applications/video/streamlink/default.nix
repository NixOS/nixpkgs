{ stdenv, pythonPackages, fetchFromGitHub, rtmpdump, ffmpeg }:

pythonPackages.buildPythonApplication rec {
  version = "0.13.0";
  name = "streamlink-${version}";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = "${version}";
    sha256 = "17i5j5a69d28abg13md2r2ycxgmd5h1pjy0pgca1zcqaqfq4v05x";
  };

  postPatch = ''
    # Fix failing test. This can be removed after version 0.13.0, see:
    # https://github.com/streamlink/streamlink/commit/a27e1a2d8eec6eb23c6e1dc280c6afc1cd0b5b32
    substituteInPlace tests/test_plugin.py --replace "lambda: datetime" "datetime"
  '';

  checkInputs = with pythonPackages; [ pytest mock requests-mock freezegun ];

  propagatedBuildInputs = (with pythonPackages; [ pycryptodome requests iso-639 iso3166 websocket_client isodate ]) ++ [ rtmpdump ffmpeg ];

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
