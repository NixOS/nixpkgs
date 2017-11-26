{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  unpaper,
  ghostscript,
  tesseract,
  qpdf,
  glibcLocales,
  pytest,
  pytest_xdist,
  pytestcov,
  setuptools_scm,
  pytest-helpers-namespace,
  pytestrunner,
  ruffus,
  pillow,
  reportlab,
  pypdf2,
  img2pdf,
  cffi
}:



buildPythonApplication rec {
  version = "5.4.3";
  name = "OCRmyPDF-${version}";

  src = fetchFromGitHub {
    owner = "jbarlow83";
    repo = "OCRmyPDF";
    rev = "v${version}";
    sha256 = "0vnn6g69vkqldbx76llmyz8h9ia7mkxcp290mxdsydy4bjjik6zf";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "ruffus == 2.6.3" "ruffus" \
      --replace "Pillow == 4.3.0" "Pillow" \
      --replace "reportlab == 3.4.0" "reportlab" \
      --replace "PyPDF2 == 1.26.0" "PyPDF2" \
      --replace "img2pdf == 0.2.4" "img2pdf" \
      --replace "cffi == 1.11.2" "cffi"
    substituteInPlace test_requirements.txt \
      --replace "pytest >= 3.0" "pytest"
    substituteInPlace ocrmypdf/lib/compile_leptonica.py \
      --replace "©" "(c)"
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
  '';

  buildInputs = [ glibcLocales setuptools_scm ];

  checkInputs = [  pytest pytest_xdist pytestcov pytest-helpers-namespace pytestrunner ];

  # Issues with leptonica causes it to fail the tests. While this isn't fixed,
  # only the --deskew option isn't working. All other options work just fine.
  # https://github.com/jbarlow83/OCRmyPDF/issues/202#issuecomment-346965050
  doCheck = false;

  propagatedBuildInputs = [
    ruffus
    pillow
    reportlab
    pypdf2
    img2pdf
    cffi
    unpaper
    ghostscript
    tesseract
    qpdf
  ];

  meta = with lib; {
    homepage = https://github.com/jbarlow83/OCRmyPDF;
    description = "Adds an OCR text layer to scanned PDF files, allowing them to be searched or copy-pasted.";
    license = licenses.mit;
    maintainers = with maintainers; [ hyper_ch ];
  };
}
