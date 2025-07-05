{
  lib,
  dbus,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "autosuspend";
  version = "7.2.0";
  pyproject = true;

  disabled = python3.pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "languitar";
    repo = "autosuspend";
    tag = "v${version}";
    hash = "sha256-of2b5K4ccONPGZfUwEIoFs86xLM2aLCV8tVGxVqykiQ=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    dbus-python
    icalendar
    jsonpath-ng
    lxml
    mpd2
    portalocker
    psutil
    python-dateutil
    pytz
    requests
    requests-file
    tzlocal
  ];

  nativeCheckInputs = with python3.pkgs; [
    dbus
    freezegun
    pytest-cov-stub
    pytest-datadir
    pytest-httpserver
    pytest-mock
    pytestCheckHook
    python-dbusmock
  ];

  # Disable tests that need root
  disabledTests = [
    "test_smoke"
    "test_multiple_sessions"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Daemon to automatically suspend and wake up a system";
    homepage = "https://autosuspend.readthedocs.io";
    changelog = "https://github.com/languitar/autosuspend/releases/tag/${src.tag}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      bzizou
      anthonyroussel
    ];
    mainProgram = "autosuspend";
    platforms = platforms.linux;
  };
}
