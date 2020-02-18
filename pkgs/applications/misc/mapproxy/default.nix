{ lib
, pkgs
, python
}:
let
  py = python.override {
    packageOverrides = self: super: {
      pyproj = super.pyproj.overridePythonAttrs (oldAttrs: rec {
      version = "1.9.6";
      src = pkgs.fetchFromGitHub {
        owner = "pyproj4";
        repo = "pyproj";
        rev = "v${version}rel";
        sha256 = "sha256:18v4h7jx4mcc0x2xy8y7dfjq9bzsyxs8hdb6v67cabvlz2njziqy";
      };
      nativeBuildInputs = with python.pkgs; [ cython ];
      patches = [ ];
      checkPhase = ''
        runHook preCheck
        pushd unittest  # changing directory should ensure we're importing the global pyproj
        ${python.interpreter} test.py && ${python.interpreter} -c "import doctest, pyproj, sys; sys.exit(doctest.testmod(pyproj)[0])"
        popd
        runHook postCheck
      '';
      });
    };
  };
in
with py.pkgs;
buildPythonApplication rec {
  pname = "MapProxy";
  version = "1.12.0";
  src = fetchPypi {
  inherit pname version;
  sha256 = "622e3a7796ef861ba21e42231b49c18d00d75f03eaf3f01a2b7687be7568e2ec";
  };
  prePatch = ''
    substituteInPlace mapproxy/util/ext/serving.py --replace "args = [sys.executable] + sys.argv" "args = sys.argv"
  '';
  propagatedBuildInputs = [
    boto3 # needed for caches service
    pillow
    pyyaml
    pyproj
    shapely
    gdal
    lxml
    setuptools
  ];
  # Tests are disabled:
  # 1) Dependency list is huge.
  #    https://github.com/mapproxy/mapproxy/blob/master/requirements-tests.txt
  #
  # 2) There are security issues with package Riak
  #    https://github.com/NixOS/nixpkgs/issues/33876
  #    https://github.com/NixOS/nixpkgs/pull/56480
  doCheck = false;
  meta = with lib; {
  description = "MapProxy is an open source proxy for geospatial data";
  homepage = https://mapproxy.org/;
  license = licenses.asl20;
  maintainers = with maintainers; [ rakesh4g ];
  };
}