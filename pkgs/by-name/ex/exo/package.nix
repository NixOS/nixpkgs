{ lib, stdenv, fetchFromGitHub, python3Packages, gitUpdater, }:

python3Packages.buildPythonApplication rec {
  pname = "exo";
  version = "0.0.13-alpha";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exo-explore";
    repo = "exo";
    tag = "v${version}";
    hash = "sha256-qUDVWtDXVUo+JvfK0TC+DK/Z6I5lbuThomxjNwQ+Tlw=";
  };

  mlx = python3Packages.buildPythonPackage rec {
    pname = "mlx";
    version = "0.22.0";
    format = "wheel";
    src = python3Packages.fetchPypi {
      inherit pname version format;
      python = "cp312";
      abi = "cp312";
      dist = "cp312";
      platform = "macosx_14_0_arm64";
      hash = "sha256-HfrOgigEg/FPJVfaKv6Mll97Ccqkva6WLPp4iX0L7XM=";
    };
  };

  mlx-lm = python3Packages.buildPythonPackage rec {
    pname = "mlx_lm";
    version = "0.21.1";
    src = python3Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-cB1NHeknhcwk5lGijUaJTfVnGHcRzJlMiMtyR/PRzeA=";
    };
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
    (nuitka.overridePythonAttrs (old: { doCheck = false; }))
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
    mlx
    mlx-lm
    uvloop
    (pkgs.python312Packages.tinygrad.overridePythonAttrs
      (old: { doCheck = false; }))

  ];

  pythonImportsCheck = [ "exo" "exo.inference.tinygrad.models" ];

  ## Tests

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  disabledTestPaths = [ "test/test_tokenizers.py" ];

  # Tests require `mlx` which is not supported on linux.
  #doCheck = stdenv.hostPlatform.isDarwin;

  # Tests hang on darwin 14
  doCheck = false;

  passthru = { updateScript = gitUpdater { rev-prefix = "v-"; }; };

  meta = {
    description = "Run your own AI cluster at home with everyday devices";
    homepage = "https://github.com/exo-explore/exo";
    changelog = "https://github.com/exo-explore/exo/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "exo";
  };
}

