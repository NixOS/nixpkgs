{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  huggingface-hub,
  jsonlines,
  mean-average-precision,
  numpy,
  opencv-python-headless,
  pillow,
  torch,
  torchvision,
  tqdm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docling-ibm-models";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "docling-ibm-models";
    rev = "refs/tags/v${version}";
    hash = "sha256-QZvkkazxgkGuSQKIYI+YghH7pLlDSEbCGhg89gZsOpk=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    huggingface-hub
    jsonlines
    mean-average-precision
    numpy
    opencv-python-headless
    pillow
    torch
    torchvision
    tqdm
  ];

  pythonRelaxDeps = [
    "mean_average_precision"
    "pillow"
    "torchvision"
  ];

  pythonImportsCheck = [
    "docling_ibm_models"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Requires network access
    "test_layoutpredictor"
    "test_tf_predictor"
  ];

  meta = {
    changelog = "https://github.com/DS4SD/docling-ibm-models/blob/${src.rev}/CHANGELOG.md";
    description = "Docling IBM models";
    homepage = "https://github.com/DS4SD/docling-ibm-models";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
