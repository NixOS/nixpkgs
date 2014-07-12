{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-spotify-${version}";

  version = "1.1.3";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-spotify/archive/v${version}.tar.gz";
    sha256 = "09s6841qb24nrmlc2izb8vxbgv185ddra6ndskrsw907hfli2kl6";
  };

  propagatedBuildInputs = [ mopidy pythonPackages.pyspotify ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://www.mopidy.com/;
    description = "Mopidy extension for playing music from Spotify.";
    license = licenses.asl20;
    maintainers = [ maintainers.rickynils ];
    hydraPlatforms = [];
  };
}
