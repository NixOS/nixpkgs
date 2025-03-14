{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "pgsrip";
  version = "0.1.11";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "pgsrip";
    rev = version;
    hash = "sha256-H9gZXge+m/bCq25Fv91oFZ8Cq2SRNrKhOaDrLZkjazg=";
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
    "numpy"
    "setuptools"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rip your PGS subtitles";
    homepage = "https://github.com/ratoaq2/pgsrip";
    changelog = "https://github.com/ratoaq2/pgsrip/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "pgsrip";
  };
}
