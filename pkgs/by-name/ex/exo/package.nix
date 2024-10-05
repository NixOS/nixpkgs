{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "exo";
  version = "0-unstable-2024-10-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exo-explore";
    repo = "exo";
    rev = "2b9dec20eb25f8708455e13eabc744d653b7a286";
    hash = "sha256-Iz65bs/ntTrxcifrPemAlK8zVjbwQfXsnUlcE1r4E/A=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [ "uuid" ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-cors
    aiofiles
    blobfile
    grpcio
    grpcio-tools
    hf-transfer
    huggingface-hub
    jinja2
    netifaces
    numpy
    pillow
    prometheus-client
    protobuf
    psutil
    pynvml
    requests
    rich
    safetensors
    tailscale
    tenacity
    tiktoken
    tokenizers
    tqdm
    transformers
    tinygrad
  ];

  pythonImportsCheck = [
    "exo"
    "exo.inference.tinygrad.models"
  ];

  nativeCheckInputs = with python3Packages; [
    mlx
    pytestCheckHook
  ];

  disabledTestPaths = [
    "test/test_tokenizers.py"
  ];

  # Tests require `mlx` which is not supported on linux.
  doCheck = stdenv.isDarwin;

  meta = {
    description = "Run your own AI cluster at home with everyday devices";
    homepage = "https://github.com/exo-explore/exo";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "exo";
  };
}
