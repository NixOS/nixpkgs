{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  unstableGitUpdater,
}:
python3Packages.buildPythonApplication {
  pname = "exo";
  version = "0-unstable-2024-12-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exo-explore";
    repo = "exo";
    rev = "cfedcec3a651f27085e1913f4bd42a699fa82076";
    hash = "sha256-OPGWmIfIVW/1lJg+4iXRvzN6bY8+LzWx8SOgBUXjPQ0=";
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
    netifaces
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
    updateScript = unstableGitUpdater {
      hardcodeZeroVersion = true;
    };
  };

  meta = {
    description = "Run your own AI cluster at home with everyday devices";
    homepage = "https://github.com/exo-explore/exo";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "exo";
  };
}
