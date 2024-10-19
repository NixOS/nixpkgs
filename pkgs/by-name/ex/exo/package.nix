{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "exo";
  version = "0-unstable-2024-10-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exo-explore";
    repo = "exo";
    rev = "c1a26cd7fa447b2802a4bececfd7cb9d316c0600";
    hash = "sha256-jtcfGmk03Yf5IaswIvi6N9oMXzNPYlJBf4WMLkogUVo=";
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
    nvidia-ml-py
    pillow
    prometheus-client
    protobuf
    psutil
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
