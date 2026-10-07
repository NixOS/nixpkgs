{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "dvr-scan";
  version = "1.8.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Breakthrough";
    repo = "DVR-Scan";
    tag = "v${version}-release";
    hash = "sha256-+1liOZu8360aQlNwWaJXJQS/0POT9bTcIUkDg/v4lxU=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    numpy
    opencv-contrib-python
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
    writableTmpDirAsHomeHook
  ];

  pythonRelaxDeps = [
    "opencv-contrib-python"
  ];

  disabledTests = [
    # frame number mismatches with opencv 4.13+ (upstream issue #257)
    "test_pre_event_shift_with_frame_skip"
    "test_start_end_time"
    "test_start_duration"
    "test_default"
    "test_concatenate"
    "test_scan_only"
    "test_quiet_mode"
    "test_config_file"
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
