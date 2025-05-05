{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  packaging,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "qbittorrent-api";
  version = "2025.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "qbittorrent_api";
    inherit version;
    hash = "sha256-E3kvY3zhxf7bbnkfBR4LnjlRfz+PKcWvt7M8uvIFoRg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    requests
    urllib3
  ];

  # Tests require internet access
  doCheck = false;

  pythonImportsCheck = [ "qbittorrentapi" ];

  meta = {
    description = "Python client implementation for qBittorrent's Web API";
    homepage = "https://github.com/rmartin16/qbittorrent-api";
    changelog = "https://github.com/rmartin16/qbittorrent-api/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ savyajha ];
  };
}
