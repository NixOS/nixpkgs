{ lib, python3Packages, fetchPypi, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Scrobbler";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11vxgax4xgkggnq4fr1rh2rcvzspkkimck5p3h4phdj3qpnj0680";
  };

  propagatedBuildInputs = with python3Packages; [ mopidy pylast ];

  # no tests implemented
  doCheck = false;
  pythonImportsCheck = [ "mopidy_scrobbler" ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-scrobbler";
    description = "Mopidy extension for scrobbling played tracks to Last.fm";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakeisnt ];
  };
}
