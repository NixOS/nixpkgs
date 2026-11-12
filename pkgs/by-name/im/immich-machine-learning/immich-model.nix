{
  lib,
  fetchFromGitHub,
  immich,
  buildPythonPackage,
  # build-system
  hatchling,
  # dependencies
  numpy,
  onnx,
  onnx-ir,
  onnxscript,
  safetensors,
}:
buildPythonPackage (finalAttrs: {
  pname = "immich-model";
  version = "0-unstable-2026-10-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "ml-models";
    rev = "a1eeff2c2118d76067efecf4cc4630998eac519a";
    hash = "sha256-q6J+QxyqQACkjoqEQk4YoKR0eP8vSzkihu5R+5oTXE0=";
  };

  pythonRelaxDeps = [
    "safetensors"
  ];

  build-system = [
    hatchling
  ];

  dependencies = [
    numpy
    onnx
    onnx-ir
    onnxscript
    safetensors
  ];

  meta = {
    description = "${immich.meta.description} (machine learning models)";
    homepage = "https://github.com/immich-app/ml-models";
    license = lib.licenses.agpl3Only;
    inherit (immich.meta) maintainers platforms;
  };
})
