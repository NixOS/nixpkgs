{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  html5lib,
  lxml,
  pytestCheckHook,
  pythonOlder,
  regex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "readabilipy";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alan-turing-institute";
    repo = "ReadabiliPy";
    rev = "refs/tags/v${version}";
    hash = "sha256-XrmdQjLFYdadWeO5DoKAQeEdta+6T6BqfvGlDkzLMyM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    beautifulsoup4
    html5lib
    lxml
    regex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "readabilipy" ];

  disabledTests = [
    # AssertionError
    "test_extract_simple_article_with_readability_js"
    "test_extract_article_from_page_with_readability_js"
    "test_plain_element_with_comments"
    "test_content_digest_on_filled_and_empty_elements"
  ];

  disabledTestPaths = [
    # Exclude benchmarks
    "tests/test_benchmarking.py"
  ];

  meta = with lib; {
    description = "HTML content extractor";
    mainProgram = "readabilipy";
    homepage = "https://github.com/alan-turing-institute/ReadabiliPy";
    changelog = "https://github.com/alan-turing-institute/ReadabiliPy/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
