{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-spotify-${version}";
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-spotify/archive/v${version}.tar.gz";
    sha256 = "1mh87w4j0ypvsrnax7kkjgfxfpnw3l290jvfzg56b8qlwf20khjl";
  };

  propagatedBuildInputs = [ mopidy pythonPackages.pyspotify ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://www.mopidy.com/;
    description = "Mopidy extension for playing music from Spotify";
    license = licenses.asl20;
    maintainers = [ maintainers.rickynils ];
    hydraPlatforms = [];
  };
}
