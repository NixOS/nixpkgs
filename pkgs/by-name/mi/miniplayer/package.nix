{
  lib,
  python3Packages,
  fetchPypi,
}:

with python3Packages;

buildPythonApplication (finalAttrs: {
  pname = "miniplayer";
  version = "1.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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

  meta = {
    description = "Curses-based MPD client with basic functionality that can also display an album art";
    homepage = "https://github.com/GuardKenzie/miniplayer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
