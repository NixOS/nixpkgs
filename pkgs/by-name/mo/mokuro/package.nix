{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mokuro";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kha-white";
    repo = "mokuro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cdbkculYPPWCSqBufpgt4EU3ne6KU2Dxk0xsvkdMZHA=";
    fetchSubmodules = true;
  };

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
    changelog = "https://github.com/kha-white/mokuro/releases/tag/${finalAttrs.src.tag}";
    description = "Read Japanese manga inside browser with selectable text";
    homepage = "https://github.com/kha-white/mokuro";
    license = lib.licenses.gpl3Only;
    mainProgram = "mokuro";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
