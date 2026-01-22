{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "owocr";
  version = "1.7.5-unstable-2024-06-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AuroraWright";
    repo = "owocr";
    rev = "743c64aa16a760f87bf5ea1f54364d828eb3eddb"; # no tags
    hash = "sha256-TXQwJRgRp7fZBN0r4XGVtlb+iOMRqEUf+LbfBG/vsr8=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    fire
    jaconv
    loguru
    numpy
    pillow
    pyperclipfix
    pynput
    websockets
    desktop-notifier
    mss
    pysbd
    langid
    psutil
    pywinctl
    # extra optional libs for OCR engines
    azure-ai-vision-imageanalysis
    easyocr
    pyjson5 # Google Lens
    google-cloud-vision
    manga-ocr
    rapidocr
    requests # winRT OCR
  ];

  doCheck = false; # no tests

  meta = {
    description = "Optical character recognition for Japanese text";
    homepage = "https://github.com/AuroraWright/owocr";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
