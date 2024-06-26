{
  lib,
  python3Packages,
  fetchPypi,
  mopidy,
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-MPD";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CeLMRqj9cwBvQrOx7XHVV8MjDjwOosONVlsN2o+vTVM=";
  };

  propagatedBuildInputs = [ mopidy ];

  # no tests implemented
  doCheck = false;
  pythonImportsCheck = [ "mopidy_mpd" ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-mpd";
    description = "Mopidy extension for controlling playback from MPD clients";
    license = licenses.asl20;
    maintainers = [ maintainers.tomahna ];
  };
}
