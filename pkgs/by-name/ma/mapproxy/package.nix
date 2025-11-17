{
  lib,
  fetchFromGitHub,

  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mapproxy";
  version = "5.1.1";
  pyproject = true;
  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mapproxy";
    repo = "mapproxy";
    tag = version;
    hash = "sha256-4TRaY/NfOjmq5v+6Rv2UGwF1rqnw4UggVOX2HMa5mVI=";
  };

  prePatch = ''
    substituteInPlace mapproxy/util/ext/serving.py --replace-warn "args = [sys.executable] + sys.argv" "args = sys.argv"
  '';

  build-system = with python3Packages; [ setuptools ];

  pythonRemoveDeps = [ "future" ];

  dependencies = with python3Packages; [
    boto3 # needed for caches service
    jsonschema
    pillow
    pyyaml
    pyproj
    shapely
    gdal
    lxml
    werkzeug
  ];

  # Tests are disabled:
  # 1) Dependency list is huge.
  #    https://github.com/mapproxy/mapproxy/blob/master/requirements-tests.txt
  doCheck = false;

  pythonImportsCheck = [ "mapproxy" ];

  meta = {
    description = "Open source proxy for geospatial data";
    homepage = "https://mapproxy.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rakesh4g ];
    teams = [ lib.teams.geospatial ];
  };
}
