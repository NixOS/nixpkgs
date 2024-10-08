{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "exo";
  version = "0-unstable-2024-10-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exo-explore";
    repo = "exo";
    rev = "7b2a523fd1e5f1281d89bc1f664a29dc2003b787";
    hash = "sha256-o4tNbU9oa7WsAQ6eiTHqQVhliXbG/Y8d7PeH2TTWgGk=";
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
