{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pgsrip";
  version = "0.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "pgsrip";
    tag = finalAttrs.version;
    hash = "sha256-8UzElhMdhjZERdogtAbkcfw67blk9lOTQ09vjF5SXm4=";
  };

  pythonRelaxDeps = [
    "click"
    "opencv-python"
    "setuptools"
    "trakit"
  ];

  build-system = with python3Packages; [ poetry-core ];

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

  pythonImportsCheck = [ "pgsrip" ];

  meta = {
    description = "Rip your PGS subtitles";
    homepage = "https://github.com/ratoaq2/pgsrip";
    changelog = "https://github.com/ratoaq2/pgsrip/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "pgsrip";
  };
})
