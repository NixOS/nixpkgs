{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-mpd";
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-MPD";
    hash = "sha256-CeLMRqj9cwBvQrOx7XHVV8MjDjwOosONVlsN2o+vTVM=";
  };

  build-system = [ pythonPackages.setuptools ];

  dependencies = [ mopidy ];

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
