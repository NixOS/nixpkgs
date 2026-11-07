{
  lib,
  brotli,
  buildPythonPackage,
  camelot,
  defusedxml,
  fetchFromGitHub,
  fonttools,
  lxml,
  pillow,
  pytest-cov-stub,
  pytestCheckHook,
  qrcode,
  setuptools,
  uharfbuzz,
}:

buildPythonPackage rec {
  pname = "fpdf2";
  version = "2.8.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "py-pdf";
    repo = "fpdf2";
    tag = version;
    hash = "sha256-bMVi0ZNV9Al9dxH8t801y4zkJpNmQUVTeMoOh+DDzFA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    defusedxml
    fonttools
    pillow
  ];

  nativeCheckInputs = [
    brotli
    camelot
    lxml
    pytest-cov-stub
    pytestCheckHook
    qrcode
    uharfbuzz
  ];

  disabledTestPaths = [
    "test/table/test_table_extraction.py" # tabula-py not packaged yet
    "test/signing/test_sign.py" # endesive not packaged yet
  ];

  disabledTests = [
    "test_png_url" # tries to download file
    "test_page_background" # tries to download file
    "test_twitter_emoji_shaping" # hash mismatch
    "test_twitter_emoji_text" # hash mismatch
  ];

  meta = {
    homepage = "https://github.com/py-pdf/fpdf2";
    description = "Simple PDF generation for Python";
    changelog = "https://github.com/py-pdf/fpdf2/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jfvillablanca ];
  };
}
