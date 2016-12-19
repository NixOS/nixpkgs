{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-spotify-${version}";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-spotify/archive/v${version}.tar.gz";
    sha256 = "0w7bhq6nz2xly5g72xd98r7lyzmx7nzfdpghk7vklkx0x41qccz8";
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
