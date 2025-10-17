{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "pgsrip";
  version = "0.1.12";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "pgsrip";
    tag = version;
    hash = "sha256-8UzElhMdhjZERdogtAbkcfw67blk9lOTQ09vjF5SXm4=";
  };

  build-system = [ python3Packages.poetry-core ];

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

  pythonRelaxDeps = [
    "click"
    "opencv-python"
    "setuptools"
  ];

  meta = {
    description = "Rip your PGS subtitles";
    homepage = "https://github.com/ratoaq2/pgsrip";
    changelog = "https://github.com/ratoaq2/pgsrip/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "pgsrip";
  };
}
