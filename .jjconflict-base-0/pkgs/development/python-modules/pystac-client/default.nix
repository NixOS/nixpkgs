{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  pystac,
  pytest-benchmark,
  pytest-console-scripts,
  pytest-mock,
  pytest-recording,
  python-dateutil,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pystac-client";
  version = "0.8.4";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "stac-utils";
    repo = "pystac-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-EetS0MD5DLBR+ht9YfD+oRdfHbVONuVHdSZj3FQ5Sm8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pystac
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
    pytest-console-scripts
    pytest-mock
    pytest-recording
    requests-mock
  ];

  pytestFlagsArray = [
    # Tests accessing Internet
    "-m 'not vcr'"
  ];

  pythonImportsCheck = [ "pystac_client" ];

  meta = {
    description = "A Python client for working with STAC Catalogs and APIs";
    homepage = "https://github.com/stac-utils/pystac-client";
    license = lib.licenses.asl20;
    maintainers = lib.teams.geospatial.members;
  };
}
