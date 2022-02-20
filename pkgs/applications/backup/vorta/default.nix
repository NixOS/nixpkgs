{ lib
, python3Packages
, fetchFromGitHub
, wrapQtAppsHook
, borgbackup
, qt5
}:

python3Packages.buildPythonApplication rec {
  pname = "vorta";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = "vorta";
    rev = "v${version}";
    sha256 = "06sb24pimq9ckdkp9hzp4r9d3i21kxacsx5b7x9q99qcwf7h6372";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3Packages; [
    paramiko
    peewee
    pyqt5
    python-dateutil
    psutil
    qdarkstyle
    secretstorage
    appdirs
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
    --replace setuptools_git "" \
    --replace pytest-runner ""

    substituteInPlace src/vorta/assets/metadata/com.borgbase.Vorta.desktop \
    --replace Exec=vorta "Exec=$out/bin/vorta" \
    --replace com.borgbase.Vorta "com.borgbase.Vorta-symbolic"
  '';

  postInstall = ''
    install -Dm644 src/vorta/assets/metadata/com.borgbase.Vorta.desktop $out/share/applications/com.borgbase.Vorta.desktop
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ borgbackup ]}
    )
  '';

  checkInputs = with python3Packages; [
    pytest-qt
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    # For tests/test_misc.py::test_autostart
    mkdir -p $HOME/.config/autostart
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
  '';

  disabledTestPaths = [
    "tests/test_archives.py"
    "tests/test_borg.py"
    "tests/test_lock.py"
    "tests/test_notifications.py"
  ];

  disabledTests = [
    "diff_archives_dict_issue-Users"
    "diff_archives-test"
    "test_repo_unlink"
    "test_repo_add_success"
    "test_ssh_dialog"
    "test_create"
    "test_scheduler_create_backup"
  ];

  meta = with lib; {
    license = licenses.gpl3Only;
    homepage = "https://vorta.borgbase.com/";
    maintainers = with maintainers; [ ma27 ];
    description = "Desktop Backup Client for Borg";
    platforms = platforms.linux;
  };
}
