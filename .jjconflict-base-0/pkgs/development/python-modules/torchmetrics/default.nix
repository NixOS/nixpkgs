{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  numpy,
  lightning-utilities,
  packaging,
  pretty-errors,

  # buildInputs
  torch,

  # tests
  cloudpickle,
  psutil,
  pytestCheckHook,
  pytest-doctestplus,
  pytest-xdist,
  pytorch-lightning,
  scikit-image,
  scikit-learn,

  # passthru
  torchmetrics,
}:

let
  pname = "torchmetrics";
  version = "1.4.3";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "torchmetrics";
    rev = "refs/tags/v${version}";
    hash = "sha256-527cHPFdFw/JajHe7Kkz7+zl4EfePaLx77I2OTjjxaA=";
  };

  dependencies = [
    numpy
    lightning-utilities
    packaging
    pretty-errors
  ];

  # Let the user bring their own instance
  buildInputs = [ torch ];

  nativeCheckInputs = [
    cloudpickle
    psutil
    pytestCheckHook
    pytest-doctestplus
    pytest-xdist
    pytorch-lightning
    scikit-image
    scikit-learn
  ];

  # A cyclic dependency in: integrations/test_lightning.py
  doCheck = false;
  passthru.tests.check = torchmetrics.overridePythonAttrs (_: {
    pname = "${pname}-check";
    doCheck = true;
    # We don't have to install because the only purpose
    # of this passthru test is to, well, test.
    # This fixes having to set `catchConflicts` to false.
    dontInstall = true;
  });

  disabledTests = [
    # `IndexError: list index out of range`
    "test_metric_lightning_log"
  ];

  disabledTestPaths = [
    # These require too many "leftpad-level" dependencies
    # Also too cross-dependent
    "tests/unittests"

    # A trillion import path mismatch errors
    "src/torchmetrics"
  ];

  pythonImportsCheck = [ "torchmetrics" ];

  meta = {
    description = "Machine learning metrics for distributed, scalable PyTorch applications (used in pytorch-lightning)";
    homepage = "https://lightning.ai/docs/torchmetrics/";
    changelog = "https://github.com/Lightning-AI/torchmetrics/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
