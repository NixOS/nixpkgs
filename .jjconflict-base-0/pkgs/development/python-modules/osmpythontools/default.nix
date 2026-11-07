{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  geojson,
  lxml,
  matplotlib,
  numpy,
  pandas,
  setuptools,
  ujson,
  xarray,
}:

buildPythonPackage rec {
  pname = "osmpythontools";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mocnik-science";
    repo = "osm-python-tools";
    tag = "v${version}";
    hash = "sha256-ajZJSuMbku08vHvn4fqsLqCS/E2XR3uVqiH7R1GHH5o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    geojson
    lxml
    matplotlib
    numpy
    pandas
    ujson
    xarray
  ];

  # tests touch network
  doCheck = false;

  pythonImportsCheck = [
    "OSMPythonTools"
    "OSMPythonTools.api"
    "OSMPythonTools.data"
    "OSMPythonTools.element"
    "OSMPythonTools.nominatim"
    "OSMPythonTools.overpass"
  ];

  meta = {
    description = "Library to access OpenStreetMap-related services";
    longDescription = ''
      The python package OSMPythonTools provides easy access to
      OpenStreetMap-related services, among them an Overpass endpoint,
      Nominatim, and the OpenStreetMap editing API.
    '';
    homepage = "https://github.com/mocnik-science/osm-python-tools";
    license = lib.licenses.gpl3Only;
    changelog = "https://raw.githubusercontent.com/mocnik-science/osm-python-tools/v${version}/version-history.md";
    maintainers = with lib.maintainers; [ das-g ];
    teams = [ lib.teams.geospatial ];
  };
}
