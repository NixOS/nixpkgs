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

  nativeBuildInputs = with python3Packages; [
    poetry-core
    pythonRelaxDepsHook
    setuptools
  ];

  dependencies = with python3Packages; [
    babelfish
    cleanit
    click
    numpy
    opencv4
    pysrt
    pytesseract
    trakit
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "opencv-python" "opencv"
  '';

  pythonRelaxDeps = [
    "numpy"
    "setuptools"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ratoaq2/pgsrip/releases/tag/${version}";
    description = "Rip your PGS subtitles";
    homepage = "https://github.com/ratoaq2/pgsrip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "pgsrip";
  };
}
