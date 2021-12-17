{ lib, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-spotify";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-spotify";
    rev = "v${version}";
    sha256 = "1qsac2yy26cdlsmxd523v8ayacs0s6jj9x79sngwap781i63zqrm";
  };

  propagatedBuildInputs = [ mopidy pythonPackages.pyspotify ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for playing music from Spotify";
    license = licenses.asl20;
    maintainers = with maintainers; [ rski ];
    hydraPlatforms = [ ];
  };
}
