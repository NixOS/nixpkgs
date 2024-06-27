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

python3Packages.buildPythonPackage rec {
  pname = "ocrodjvu";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FriedrichFroebel";
    repo = "ocrodjvu";
    rev = version;
    hash = "sha256-e1EwhJc65ghHKtvnpPONGtYPrch5Io1pXXmt6e8K67Y=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  nativeBuildInputs = with python3Packages; [
      cython
      djvulibre
      glibcLocales
      libxml2
      libxml2Python
      packaging
      pkg-config
      tesseract5
    ]
    ++ lib.optionals withCuneiform cuneiform
    ++ lib.optionals withGocr gocr
    ++ lib.optionals withOcrad ocrad;

  propagatedBuildInputs = with python3Packages; [
    lxml
    python-djvulibre
  ];

  buildInputs = with python3Packages;
    [
      docbook-xsl-ns
      html5lib
      libxslt
      pillow
      pyicu
      tesseract5
    ]
    ++ lib.optionals withCuneiform cuneiform
    ++ lib.optionals withGocr gocr
    ++ lib.optionals withOcrad ocrad;

  nativeCheckInputs = [ python3Packages.unittestCheckHook ];

  unittestFlagsArray = [
    "tests"
    "-v"
  ];

  meta = with lib; {
    description = "Wrapper for OCR systems that allows you to perform OCR on DjVu files";
    homepage = "https://github.com/FriedrichFroebel/ocrodjvu";
    changelog = "https://github.com/FriedrichFroebel/ocrodjvu/blob/${version}/doc/changelog";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dansbandit ];
  };
}
