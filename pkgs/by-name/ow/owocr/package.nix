{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "owocr";
  version = "1.26.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AuroraWright";
    repo = "owocr";
    tag = finalAttrs.version;
    hash = "sha256-ZISL0K16Ilmne8SZ5+L7FSxjZJd8j7tDklUOjPvw7HM=";
  };

  # we use pystray directly to avoid making a new package
  # that only carries a single patch for windows double click support.
  # pythonRelaxDeps was not successful in patching
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pystrayfix>=0.19.8" "pystray"
  '';

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
    python3Packages.obsws-python
    python3Packages.pystray
    python3Packages.pynputfix
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
})
