{ stdenv, pythonPackages, fetchFromGitHub, rtmpdump }:

pythonPackages.buildPythonApplication rec {
  version = "1.14.0-rc1";
  name = "streamlink-${version}";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = "ffc099b16b9a9d2c0c44081d687c50ee2e935f29";
    sha256 = "0ix2k2yd2jzcazkjjb0iczr4bv7pgx873k7bhxgb9zwplklxpw1k";
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
