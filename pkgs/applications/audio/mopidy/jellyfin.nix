{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-jellyfin";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "mopidy_jellyfin";
    hash = "sha256-2UH5wwUlt2N6WC3GYptVGs33gyJCWdPKjOiGaeBTuCA=";
  };

  build-system = [ pythonPackages.setuptools ];

  dependencies = [
    mopidy
    pythonPackages.unidecode
    pythonPackages.websocket-client
  ];

  # no tests implemented
  doCheck = false;
  pythonImportsCheck = [ "mopidy_jellyfin" ];

  meta = {
    homepage = "https://github.com/jellyfin/mopidy-jellyfin";
    description = "Mopidy extension for playing audio files from Jellyfin";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.pstn ];
  };
})
