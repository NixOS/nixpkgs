{
  lib,
  python3Packages,
  fetchFromGitHub,
  djvulibre,
  docbook-xsl-ns,
  glibcLocales,
  libxml2,
  libxml2Python,
  libxslt,
  pkg-config,
  tesseract5,
  withCuneiform ? false,
  cuneiform,
  withGocr ? false,
  gocr,
  withOcrad ? false,
  ocrad,
}:

python3Packages.buildPythonApplication rec {
  pname = "ocrodjvu";
  version = "0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FriedrichFroebel";
    repo = "ocrodjvu";
    tag = version;
    hash = "sha256-/TPo8YCE8JKKKBBeV12ilgTNDmuklwfy0TPI/7dBiOs=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = [
  ]
  ++ lib.optional withCuneiform cuneiform
  ++ lib.optional withGocr gocr
  ++ lib.optional withOcrad ocrad;

  dependencies = with python3Packages; [
    lxml
    python-djvulibre
    pyicu
    html5lib
  ];

  nativeCheckInputs = [
    python3Packages.unittestCheckHook
    python3Packages.pillow
    djvulibre
    glibcLocales
    libxml2
    libxml2Python
    tesseract5
  ];

  unittestFlagsArray = [
    "tests"
    "-v"
  ];

  meta = {
    description = "Wrapper for OCR systems that allows you to perform OCR on DjVu files";
    homepage = "https://github.com/FriedrichFroebel/ocrodjvu";
    changelog = "https://github.com/FriedrichFroebel/ocrodjvu/blob/${version}/doc/changelog";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dansbandit ];
    mainProgram = "ocrodjvu";
  };
}
