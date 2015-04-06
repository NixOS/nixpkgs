{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-spotify-${version}";

  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-spotify/archive/v${version}.tar.gz";
    sha256 = "0pwgg9xw86sjhv6w735fm0k81v0lv3gqlidgw90hr47hc4wajnzx";
  };

  propagatedBuildInputs = [ mopidy pythonPackages.pyspotify ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://www.mopidy.com/;
    description = "Mopidy extension for playing music from Spotify";
    license = licenses.asl20;
    maintainers = [ maintainers.rickynils ];
    hydraPlatforms = [];
  };
}
