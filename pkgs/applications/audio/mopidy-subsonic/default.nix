{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-subsonic-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/M/Mopidy-Subsonic/Mopidy-Subsonic-${version}.tar.gz";
    sha256 = "0wmf0a7aynvn32pf8p02d53a8vg3l33yvwfwdy4gcx93pm3psgp2";
  };

  propagatedBuildInputs = [ mopidy pythonPackages.py-sonic pythonPackages.pykka ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://www.mopidy.com/;
    description = "Mopidy backend extension for playing music from Subsonic Music Streamer";
    license = licenses.mit;
    maintainers = [ maintainers.jgillich ];
  };
}
