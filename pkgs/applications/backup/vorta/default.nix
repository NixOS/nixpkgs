{ lib
, python3Packages
, fetchFromGitHub
, wrapQtAppsHook
, borgbackup
, qt5
, stdenv
}:

python3Packages.buildPythonApplication rec {
  pname = "vorta";
  version = "0.8.12";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = "vorta";
    rev = "v${version}";
    hash = "sha256-nLdLTh1qSKvOR2cE9HWQrIWQ9L+ynX4qF+lTtKn/Ubs=";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

  buildInputs = lib.optionals stdenv.isLinux [
    qt5.qtwayland
  ];

  propagatedBuildInputs = with python3Packages; [
    peewee
    pyqt5
    python-dateutil
    psutil
    qdarkstyle
    secretstorage
    appdirs
    setuptools
    platformdirs
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
    --replace setuptools_git "" \
    --replace pytest-runner ""

    substituteInPlace src/vorta/assets/metadata/com.borgbase.Vorta.desktop \
    --replace com.borgbase.Vorta "com.borgbase.Vorta-symbolic"
  '';

  postInstall = ''
    install -Dm644 src/vorta/assets/metadata/com.borgbase.Vorta.desktop $out/share/applications/com.borgbase.Vorta.desktop
    install -Dm644 src/vorta/assets/icons/icon.svg $out/share/pixmaps/com.borgbase.Vorta-symbolic.svg
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ borgbackup ]}
    )
  '';

  nativeCheckInputs = with python3Packages; [
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
    changelog = "https://github.com/borgbase/vorta/releases/tag/v0.8.10";
    description = "Desktop Backup Client for Borg";
    homepage = "https://vorta.borgbase.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
    mainProgram = "vorta";
  };
}
