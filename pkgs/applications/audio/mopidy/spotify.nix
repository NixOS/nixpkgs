{ lib, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-spotify";
  version = "4.1.1";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-spotify/archive/v${version}.tar.gz";
    sha256 = "0054gqvnx3brpfxr06dcby0z0dirwv9ydi6gj5iz0cxn0fbi6gv2";
  };

  propagatedBuildInputs = [ mopidy pythonPackages.pyspotify ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for playing music from Spotify";
    license = licenses.asl20;
    maintainers = [];
    hydraPlatforms = [];
  };
}
