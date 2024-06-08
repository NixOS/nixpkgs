{ lib
, dbus
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "autosuspend";
  version = "7.0.0";

  disabled = python3.pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "languitar";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-AJ0ZWRxqhBJEics6XnIVWyf7pJI8MphQU4LRqSYYNSQ=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail '--cov-config=setup.cfg' ""
  '';

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
    description = "A daemon to automatically suspend and wake up a system";
    homepage = "https://autosuspend.readthedocs.io";
    changelog = "https://github.com/languitar/autosuspend/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ bzizou anthonyroussel ];
    mainProgram = "autosuspend";
    platforms = platforms.linux;
  };
}
