{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
let
  pyinputfix = python3Packages.pynput.overrideAttrs {
    version = "1.8.2";

    src = fetchFromGitHub {
      owner = "AuroraWright";
      repo = "pynputfix";
      tag = "1.8.2";
      hash = "sha256-SKw745hh0G2NoWgUUjShyjiG2NYPd4iJlWx7IeGpW/4=";
    };
  };
in
python3Packages.buildPythonApplication {
  pname = "owocr";
  version = "1.22.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AuroraWright";
    repo = "owocr";
    rev = "9b9c8b1b4f12a592877a66d727eb25a30462c177"; # no tags
    hash = "sha256-N9XbuoUbb1qxp/dFacpuDErh01oWmKRdTon3OvLaMfc=";
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
    pyinputfix
    curl-cffi
    pygobject3
    dbus-python
    pywayland
  ];

  doCheck = false; # no tests

  meta = {
    description = "Optical character recognition for Japanese text";
    homepage = "https://github.com/AuroraWright/owocr";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
