{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-gmusic-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-gmusic/archive/v${version}.tar.gz";
    sha256 = "1xryw2aixfza3brxlgjdlg0lghlb17g7kay9zy56mlzp0jr7m87j";
  };

  propagatedBuildInputs = [
    mopidy
    pythonPackages.requests
    pythonPackages.gmusicapi
    pythonPackages.cachetools
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://www.mopidy.com/;
    description = "Mopidy extension for playing music from Google Play Music";
    license = licenses.asl20;
    maintainers = [ maintainers.jgillich ];
    hydraPlatforms = [];
  };
}
