{
  ffmpeg,
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.8.1";
in
python3Packages.buildPythonApplication {
  pname = "odmpy";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ping";
    repo = "odmpy";
    tag = version;
    hash = "sha256-RWaB/W8ilAKRr0ZSISisCG8Mdgw5LXRCLOl5o1RsmbA=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  postPatch = ''
    substituteInPlace odmpy/processing/shared.py \
      --replace-fail '"ffmpeg",' '"${lib.getExe ffmpeg}",'

    substituteInPlace tests/odmpy_dl_tests.py \
      --replace-fail '"ffprobe",' '"${lib.getExe' ffmpeg "ffprobe"}",'
  '';

  dependencies = with python3Packages; [
    beautifulsoup4
    eyed3
    iso639-lang
    lxml
    mutagen
    requests
    termcolor
    tqdm
    typing-extensions
  ];

  nativeCheckInputs =
    (with python3Packages; [
      coverage
      responses
      ebooklib
    ])
    ++ [
      writableTmpDirAsHomeHook
    ];

  pythonImportsCheck = [
    "odmpy"
  ];

  patches = [
    # These tests (perhaps unintentionally?) access the network.
    ./delete_impure_tests.patch
  ];

  checkPhase = ''
    runHook preCheck

    # Strangely, this script does not have a #! nor is executable:
    # https://github.com/ping/odmpy/blob/0.8.0/.github/workflows/lint-test.yml#L85
    bash ./run_tests.sh

    runHook postCheck
  '';

  meta = {
    description = "Simple command line manager for OverDrive/Libby loans. Download your library loans from the command line";
    homepage = "https://github.com/ping/odmpy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jfly ];
    mainProgram = "odmpy";
  };
}
