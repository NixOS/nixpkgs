{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-gmusic-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-gmusic/archive/v${version}.tar.gz";
    sha256 = "0yfilzfamy1bxnmgb1xk56jrk4sz0i7vcnc0a8klrm9sc7agnm9i";
  };

  propagatedBuildInputs = [ mopidy pythonPackages.requests2 pythonPackages.gmusicapi ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://www.mopidy.com/;
    description = "Mopidy extension for playing music from Google Play Music";
    license = licenses.asl20;
    maintainers = [ maintainers.jgillich ];
    hydraPlatforms = [];
  };
}
