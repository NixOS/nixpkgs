{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "mokuro";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kha-white";
    repo = "mokuro";
    rev = "v${version}";
    hash = "sha256-+hcc3spbpktavqJ8q4kuQFpkm0PYIru6UdpkU7L8XI4=";
    fetchSubmodules = true;
  };

  pythonRelaxDeps = [ "torchvision" ];

  build-system = with python3Packages; [ setuptools-scm ];

  dependencies = with python3Packages; [
    fire
    loguru
    manga-ocr
    natsort
    numpy
    opencv-python
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
