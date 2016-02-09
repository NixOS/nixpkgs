{ stdenv, fetchFromGitHub, pythonPackages, mopidy, mopidy-spotify }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-spotify-tunigo-${version}";

  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "trygveaa";
    repo = "mopidy-spotify-tunigo";
    rev = "v${version}";
    sha256 = "0827wghbgrscncnshz30l97hgg0g5bsnm0ad8596zh7cai0ibss0";
  };

  propagatedBuildInputs = [ mopidy mopidy-spotify pythonPackages.tunigo ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for providing the browse feature of Spotify";
    license = licenses.asl20;
    maintainers = [ maintainers.spwhitt ];
  };
}
