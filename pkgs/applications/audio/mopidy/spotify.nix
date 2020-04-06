{ stdenv, fetchurl, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-spotify";
  version = "4.0.1";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-spotify/archive/v${version}.tar.gz";
    sha256 = "1ac8r8050i5r3ag1hlblbcyskqjqz7wgamndbzsmw52qi6hxk44f";
  };

  propagatedBuildInputs = [ mopidy python3Packages.pyspotify ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://www.mopidy.com/;
    description = "Mopidy extension for playing music from Spotify";
    license = licenses.asl20;
    maintainers = [];
    hydraPlatforms = [];
  };
}
