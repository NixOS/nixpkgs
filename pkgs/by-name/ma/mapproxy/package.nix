{
  lib,
  python3,
  fetchFromGitHub,
}:

with python3.pkgs;
buildPythonApplication rec {
  pname = "mapproxy";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "mapproxy";
    repo = "mapproxy";
    rev = "refs/tags/${version}";
    hash = "sha256-D3ZPcl9++yCq4zVR3WUIyu9UWQO3FT1MNyV7/Iuzkcw=";
  };

  prePatch = ''
    substituteInPlace mapproxy/util/ext/serving.py --replace "args = [sys.executable] + sys.argv" "args = sys.argv"
  '';

  dependencies = [
    boto3 # needed for caches service
    future
    jsonschema
    pillow
    pyyaml
    pyproj
    shapely
    gdal
    lxml
    setuptools
    werkzeug
  ];
  # Tests are disabled:
  # 1) Dependency list is huge.
  #    https://github.com/mapproxy/mapproxy/blob/master/requirements-tests.txt
  #
  # 2) There are security issues with package Riak
  #    https://github.com/NixOS/nixpkgs/issues/33876
  #    https://github.com/NixOS/nixpkgs/pull/56480
  doCheck = false;

  meta = {
    description = "Open source proxy for geospatial data";
    homepage = "https://mapproxy.org/";
    license = lib.licenses.asl20;
    maintainers = lib.teams.geospatial.members ++ (with lib.maintainers; [ rakesh4g ]);
  };
}
