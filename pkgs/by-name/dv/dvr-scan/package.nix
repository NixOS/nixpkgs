{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "dvr-scan";
  version = "1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Breakthrough";
    repo = "DVR-Scan";
    tag = "v${version}-release";
    hash = "sha256-IUIboOQopM3DymWBHsze8Hr+4HZHdt350TeBXT2cjAQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    numpy
    opencv4
    pillow
    platformdirs
    scenedetect
    screeninfo
    tqdm

    # GUI application
    tkinter
  ];

  nativeBuildInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    # requires write permission in $HOME for file logging (`dvr_scan/shared/__init__.py#L69`)
    "test_cli"
  ];

  meta = {
    description = "Find and extract motion events in videos";
    longDescription = ''
      Command-line application that automatically detects motion events in video files (e.g. security camera footage). DVR-Scan looks for areas in footage containing motion, and saves each event to a separate video clip. DVR-Scan is free and open-source software, and works on Windows, Linux, and Mac.
    '';
    homepage = "https://www.dvr-scan.com";
    changelog = "https://github.com/Breakthrough/DVR-Scan/releases/tag/v${version}-release";
    mainProgram = "dvr-scan";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
}
