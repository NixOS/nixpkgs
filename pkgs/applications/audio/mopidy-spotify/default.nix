{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-spotify-${version}";

  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-spotify/archive/v${version}.tar.gz";
    sha256 = "1fgxakylsx0nggis11v6bxfy8h3dl1n1v86liyfcj0xazb1mx69m";
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
