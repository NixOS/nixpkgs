{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  gitUpdater,
}:
python3Packages.buildPythonApplication rec {
  pname = "exo";
  version = "0.0.10-alpha";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exo-explore";
    repo = "exo";
    tag = "v${version}";
    hash = "sha256-JJGjr9RLiJ23mPpSsx6exs8hXx/ZkL5rl8i6Xg1vFhY=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [ "uuid" ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-cors
    aiofiles
    grpcio
    grpcio-tools
    jinja2
    numpy
    nuitka
    nvidia-ml-py
    opencv-python
    pillow
    prometheus-client
    protobuf
    psutil
    pydantic
    requests
    rich
    scapy
    tenacity
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
  doCheck = stdenv.hostPlatform.isDarwin;

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v-";
    };
  };

  meta = {
    description = "Run your own AI cluster at home with everyday devices";
    homepage = "https://github.com/exo-explore/exo";
    changelog = "https://github.com/exo-explore/exo/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "exo";
  };
}
