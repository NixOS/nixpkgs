{
  lib,
  fetchFromGitHub,

  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mapproxy";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mapproxy";
    repo = "mapproxy";
    tag = finalAttrs.version;
    hash = "sha256-1LDN0vfnJlINHCIagQWhai4uJP+Fidi/9seBoJIlLl0=";
  };

  prePatch = ''
    substituteInPlace mapproxy/util/ext/serving.py --replace-warn "args = [sys.executable] + sys.argv" "args = sys.argv"
  '';

  build-system = with python3Packages; [ setuptools ];

  pythonRemoveDeps = [ "future" ];

  dependencies = with python3Packages; [
    babel
    boto3 # needed for caches service
    jinja2
    jsonschema
    pillow
    python-dateutil
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
})
