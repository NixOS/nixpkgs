{ stdenv, pythonPackages, fetchFromGitHub, rtmpdump, ffmpeg }:

pythonPackages.buildPythonApplication rec {
  version = "0.14.2";
  name = "streamlink-${version}";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = "${version}";
    sha256 = "1njwfy1h8a9n5z6crrfnknlw4ys0bap2jam6ga6njgkd10aly9qr";
  };

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
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ dezgeg zraexy enzime ];
  };
}
