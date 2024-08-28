{ lib
, python3Packages
, fetchPypi
}:

with python3Packages;

buildPythonApplication rec {
  pname = "miniplayer";
  version = "1.8.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iUUsVIDLQAiaMomfA2LvvJZ2ePhgADtC6GCwIpRC1MA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    colorthief
    ffmpeg-python
    mpd2
    pillow
    pixcat
    requests
    ueberzug
  ];

  doCheck = false; # no tests

  # pythonImportsCheck is disabled because this package doesn't expose any modules.

  meta = with lib; {
    description = "Curses-based MPD client with basic functionality that can also display an album art";
    homepage = "https://github.com/GuardKenzie/miniplayer";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
