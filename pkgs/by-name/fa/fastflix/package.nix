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
  version = "6.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "FastFlix";
    tag = version;
    hash = "sha256-vlMS3Grqp6Ys1++711lwRuFC4LhcyrHtU/S3MGB4riY=";
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
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ffmpeg
      mkvtoolnix
      tesseract
    ])
  ];

  # qtWrapperArgs only exists as a shell array, so it has to be appended here
  # rather than spliced into makeWrapperArgs (which __structuredAttrs turns
  # into a real array, suppressing word splitting and expansion).
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    ffmpeg
  ];

  disabledTests = [
    # requires network and asserts the checked-out version is newer than the
    # latest upstream release, which can never hold for a tagged release
    "test_version"
  ];

  # CI=true is upstream's own switch to skip the local-only integration
  # encodes in tests/test_local_encode.py
  preCheck = ''
    export CI=true
    export QT_QPA_PLATFORM=offscreen
  '';

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
