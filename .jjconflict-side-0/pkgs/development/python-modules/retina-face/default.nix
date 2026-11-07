{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  gdown,
  keras,
  numpy,
  opencv-python,
  pillow,
  tensorflow,
  tf-keras,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "retina-face";
  version = "0.0.17";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "serengil";
    repo = "retinaface";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0s1CSGlK2bF1F2V/IuG2ZqD7CkNfHGvp1M5C3zDnuKs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gdown
    keras
    numpy
    opencv-python
    pillow
    tensorflow
    tf-keras
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # requires internet connection
  disabledTestPaths = [
    "tests/test_actions.py"
    "tests/test_align_first.py"
    "tests/test_expand_face_area.py"
  ];

  pythonImportsCheck = [ "retinaface" ];

  meta = {
    description = "Deep Face Detection Library for Python";
    homepage = "https://github.com/serengil/retinaface";
    changelog = "https://github.com/serengil/retinaface/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
})
