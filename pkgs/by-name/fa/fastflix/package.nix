{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6,
  ffmpeg,
  mkvtoolnix,
  tesseract,
}:

python3Packages.buildPythonApplication rec {
  pname = "fastflix";
  version = "6.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "FastFlix";
    tag = version;
    hash = "sha256-lmzLdlVAoEKDdX0ZplZPLOefeJNIMyYhtyBTN83E4Ek=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    babelfish
    chardet
    cleanit
    colorama
    coloredlogs
    ffmpeg-normalize
    iso639-lang
    mistune
    opencv-python
    packaging
    pathvalidate
    pgsrip
    platformdirs
    psutil
    pydantic
    pyside6
    pysrt
    pytesseract
    python-box
    requests
    reusables
    ruamel-yaml
    setuptools
    trakit
  ];

  pythonRelaxDeps = [
    "chardet"
    "mistune"
    "pathvalidate"
    "platformdirs"
    "psutil"
    "pyside6"
    "python-box"
  ];

  dontWrapQtApps = true;
  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
    "--prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
        mkvtoolnix
        tesseract
      ]
    }"
  ];

  # No tests in upstream
  doCheck = false;

  pythonImportsCheck = [ "fastflix" ];

  meta = {
    description = "Simple and friendly GUI for encoding videos";
    homepage = "https://github.com/cdgriffith/FastFlix";
    changelog = "https://github.com/cdgriffith/FastFlix/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.linux;
    mainProgram = "fastflix";
  };
}
