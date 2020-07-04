{ lib, buildPythonApplication, fetchFromGitHub, nose }:

buildPythonApplication rec {
  pname = "mbutil";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = pname;
    rev = "v${version}";
    sha256 = "06d62r89h026asaa4ryzb23m86j0cmbvy54kf4zl5f35sgiha45z";
  };

  checkInputs = [ nose ];
  checkPhase = "nosetests";

  meta = with lib; {
    description = "An importer and exporter for MBTiles";
    homepage = "https://github.com/mapbox/mbutil";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
