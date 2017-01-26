{ stdenv, pythonPackages, fetchFromGitHub, rtmpdump }:

pythonPackages.buildPythonApplication rec {
  version = "0.3.0";
  name = "streamlink-${version}";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = "${version}";
    sha256 = "1bjih6y21vmjmsk3xvhgc1innymryklgylyvjrskqw610niai59j";
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
