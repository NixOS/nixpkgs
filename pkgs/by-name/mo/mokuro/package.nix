{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "mokuro";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kha-white";
    repo = "mokuro";
    rev = "v${version}";
    hash = "sha256-w+hhUt2fTl9zrca4xotK5eNhbfragYNC0u5WDwNGb7k=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace setup.py \
        --replace-fail 'opencv-python' 'opencv'
  '';

  nativeBuildInputs = with python3Packages; [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "torchvision" ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    fire
    loguru
    manga-ocr
    natsort
    numpy
    opencv4
    pillow
    pyclipper
    requests
    scipy
    shapely
    torch
    torchsummary
    torchvision
    transformers
    tqdm
    yattag
  ];

  # tests try to use the network
  doCheck = false;

  meta = {
    description = "Read Japanese manga inside browser with selectable text";
    homepage = "https://github.com/kha-white/mokuro";
    license = lib.licenses.gpl3Only;
    mainProgram = "mokuro";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
