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
  pname = "immich-models";
  version = "0-unstable-2026-10-06";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "ml-models";
    rev = "8bf3fd1b44b0c8608f52fb6e50ddff52826576d8";
    hash = "sha256-HkgA6o3AM7evoMn86y+v/eGmQaPiE1nvnxWWgGIg4YQ=";
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
