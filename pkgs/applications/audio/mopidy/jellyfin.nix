{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-jellyfin";
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "mopidy_jellyfin";
    hash = "sha256-IKCPypMuluR0+mMALp8lB1oB1pSw4rN4rOl/eKn+Qvo=";
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

  meta = with lib; {
    homepage = "https://github.com/jellyfin/mopidy-jellyfin";
    description = "Mopidy extension for playing audio files from Jellyfin";
    license = licenses.asl20;
    maintainers = [ maintainers.pstn ];
  };
}
