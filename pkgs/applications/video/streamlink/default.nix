{ stdenv, pythonPackages, fetchFromGitHub, rtmpdump }:

pythonPackages.buildPythonApplication rec {
  version = "0.0.2";
  name = "streamlink-${version}";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = "${version}";
    sha256 = "156b3smivs8lja7a98g3qa74bawqhc4mi8w8f3dscampbxx4dr9y";
  };

  propagatedBuildInputs = (with pythonPackages; [ pycrypto requests2 ]) ++ [ rtmpdump ];

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
    maintainers = [ maintainers.dezgeg ];
  };
}
