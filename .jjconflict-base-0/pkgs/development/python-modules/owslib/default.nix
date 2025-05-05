{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytest-cov-stub,
  pytest-httpserver,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "owslib";
  version = "0.33.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "geopython";
    repo = "OWSLib";
    tag = version;
    hash = "sha256-Qp8Ow39r6u/6h9+2Qa7WMzrs6Lyek07tWYtxtvVgM/Y=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace-fail "--doctest-modules" "" \
      --replace-fail "--doctest-glob='tests/**/*.txt'" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    lxml
    python-dateutil
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [ "owslib" ];

  preCheck = ''
    # _pytest.pathlib.ImportPathMismatchError: ('owslib.swe.sensor.sml', '/build/source/build/...
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  pytestFlagsArray = [
    # Disable tests which require network access
    "-m 'not online'"
  ];

  disabledTestPaths = [
    # Tests requires network access
    "tests/test_ogcapi_connectedsystems_osh.py"
  ];

  meta = with lib; {
    description = "Client for Open Geospatial Consortium web service interface standards";
    homepage = "https://www.osgeo.org/projects/owslib/";
    changelog = "https://github.com/geopython/OWSLib/releases/tag/${src.tag}";
    license = licenses.bsd3;
    teams = [ teams.geospatial ];
  };
}
