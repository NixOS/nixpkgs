{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "exo";
  version = "0-unstable-2024-10-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exo-explore";
    repo = "exo";
    rev = "2654f290c3179aa143960e336e8985a8b6f6b72b";
    hash = "sha256-jaIeK3sn6Swi20DNnvDtSAIt3DXIN0OQDiozNUHqtjs=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = [
    "aiohttp"
    "aiofiles"
    "blobfile"
    "grpcio-tools"
    "huggingface-hub"
    "numpy"
    "protobuf"
    "pynvml"
    "safetensors"
    "tenacity"
    "tokenizers"
    "transformers"
  ];

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
