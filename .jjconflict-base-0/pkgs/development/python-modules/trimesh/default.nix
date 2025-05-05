{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
  numpy,
  lxml,
  trimesh,
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "4.6.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mikedh";
    repo = "trimesh";
    tag = version;
    hash = "sha256-ut5wCEjhC4h299TJufBOmWZHtu24Ve/BsgMaNpRDAPg=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  optional-dependencies = with python.pkgs; {
    easy =
      [
        colorlog
        manifold3d
        charset-normalizer
        lxml
        jsonschema
        networkx
        svg-path
        pycollada
        shapely
        xxhash
        rtree
        httpx
        scipy
        pillow
        # vhacdx # not packaged
        mapbox-earcut
      ]
      ++ lib.optionals embreex.meta.available [
        embreex
      ];
  };

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  disabledTests = [
    # requires loading models which aren't part of the Pypi tarball
    "test_load"
  ];

  pytestFlagsArray = [ "tests/test_minimal.py" ];

  pythonImportsCheck = [
    "trimesh"
    "trimesh.ray"
    "trimesh.path"
    "trimesh.path.exchange"
    "trimesh.scene"
    "trimesh.voxel"
    "trimesh.visual"
    "trimesh.viewer"
    "trimesh.exchange"
    "trimesh.resources"
    "trimesh.interfaces"
  ];

  meta = {
    description = "Python library for loading and using triangular meshes";
    homepage = "https://trimesh.org/";
    changelog = "https://github.com/mikedh/trimesh/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "trimesh";
    maintainers = with lib.maintainers; [
      pbsds
    ];
  };
}
