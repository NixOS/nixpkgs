{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  dm-tree,
  h5py,
  markdown-it-py,
  ml-dtypes,
  namex,
  numpy,
  optree,
  packaging,
  rich,
  tensorflow,
  pythonAtLeast,
  distutils,
}:

buildPythonPackage rec {
  pname = "keras";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "keras-team";
    repo = "keras";
    rev = "refs/tags/v${version}";
    hash = "sha256-zbeGa4g2psAofYAVuM7BNWI2gI21e739N5ZtxVfnVUg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    absl-py
    dm-tree
    h5py
    markdown-it-py
    ml-dtypes
    namex
    numpy
    optree
    packaging
    rich
    tensorflow
  ] ++ lib.optionals (pythonAtLeast "3.12") [ distutils ];

  pythonImportsCheck = [
    "keras"
    "keras._tf_keras"
  ];

  # Couldn't get tests working
  doCheck = false;

  meta = {
    description = "Multi-backend implementation of the Keras API, with support for TensorFlow, JAX, and PyTorch";
    homepage = "https://keras.io";
    changelog = "https://github.com/keras-team/keras/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
