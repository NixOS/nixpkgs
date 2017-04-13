{ stdenv, pythonPackages, fetchFromGitHub, rtmpdump, ffmpeg }:

pythonPackages.buildPythonApplication rec {
  version = "0.5.0";
  name = "streamlink-${version}";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = "${version}";
    sha256 = "08q7f1fnm3zhs1knrkl6npr4yvpblqbiwa0m9r186ny11jq2dyib";
  };

  buildInputs = with pythonPackages; [ pytest mock ];

  propagatedBuildInputs = (with pythonPackages; [ pycryptodome requests2 iso-639 iso3166 ]) ++ [ rtmpdump ffmpeg ];

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
