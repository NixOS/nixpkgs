{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pgsrip";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "pgsrip";
    tag = finalAttrs.version;
    hash = "sha256-tv5Fd6B9Fni7LEXmnZ0D14pfbOOlkO286N9848Xq80I=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    babelfish
    cleanit
    click
    numpy
    opencv-python
    pysrt
    pytesseract
    setuptools
    trakit
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    # fails to find the `git` dir, which is removed by the fetcher
    "test_repository_knowledge_is_consistent"
  ];

  pythonImportsCheck = [ "pgsrip" ];

  meta = {
    description = "Rip your PGS subtitles";
    homepage = "https://github.com/ratoaq2/pgsrip";
    changelog = "https://github.com/ratoaq2/pgsrip/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "pgsrip";
  };
})
