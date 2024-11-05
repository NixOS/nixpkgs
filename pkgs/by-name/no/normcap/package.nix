{ lib
, stdenv
, python3
, fetchFromGitHub
, tesseract4
, leptonica
, wl-clipboard
, libnotify
, xorg
, makeDesktopItem
, copyDesktopItems
}:

let

  ps = python3.pkgs;

  wrapperDeps = [
    leptonica
    tesseract4
    libnotify
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    wl-clipboard
  ];

in

ps.buildPythonApplication rec {
  pname = "normcap";
  version = "0.5.8";
  format = "pyproject";

  disabled = ps.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dynobo";
    repo = "normcap";
    rev = "refs/tags/v${version}";
    hash = "sha256-iMlW8oEt4OSipJaQ2XzBZeBVqiZP/C1sM0f5LYjv7/A=";
  };

  pythonRemoveDeps = [
    "pyside6-essentials"
  ];

  pythonRelaxDeps = [
    "shiboken6"
  ];

  build-system = [
    ps.hatchling
    ps.babel
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ps.toml
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  dependencies = [
    ps.pyside6
    ps.jeepney
  ];

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --set QT_QPA_PLATFORM xcb
      --prefix PATH : ${lib.makeBinPath wrapperDeps}
    )
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/pixmaps
    ln -s $out/${python3.sitePackages}/normcap/resources/icons/normcap.png $out/share/pixmaps/
  '';

  nativeCheckInputs = wrapperDeps ++ [
    ps.pytestCheckHook
    ps.pytest-cov-stub
    ps.pytest-instafail
    ps.pytest-qt
    ps.toml
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    ps.pytest-xvfb
    xorg.xvfb
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    # setup a virtual x11 display
    export DISPLAY=:$((2000 + $RANDOM % 1000))
    Xvfb $DISPLAY -screen 5 1024x768x8 &
    xvfb_pid=$!
  '';

  postCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
    # cleanup the virtual x11 display
    sleep 0.5
    kill $xvfb_pid
  '';

  disabledTests = [
    # requires a wayland session (no xclip support)
    "test_wl_copy"
    # RuntimeError: Please destroy the QApplication singleton before creating a new QApplication instance
    "test_get_application"
    # times out, unknown why
    "test_update_checker_triggers_checked_signal"
    # touches network
    "test_urls_reachable"
    # requires xdg
    "test_synchronized_capture"
    # flaky
    "test_normcap_ocr_testcases"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # requires display
    "test_send_via_qt_tray"
    "test_screens"
    # requires impure pbcopy
    "test_get_copy_func_with_pbcopy"
    "test_get_copy_func_without_pbcopy"
    "test_perform_pbcopy"
    "test_pbcopy"
    "test_copy"
    # NSXPCSharedListener endpointForReply:withListenerName:replyErrorCode:
    # while obtaining endpoint 'ClientCallsAuxiliary': Connection interrupted
    # since v5.0.0
    "test_introduction_initialize_checkbox_state"
    "test_introduction_checkbox_sets_return_code"
    "test_introduction_toggle_checkbox_changes_return_code"
    "test_show_introduction"
  ];

  disabledTestPaths = [
    # touches network
    "tests/tests_gui/test_downloader.py"
    # fails to import, causes pytest to freeze
    "tests/tests_gui/test_language_manager.py"
    # RuntimeError("Internal C++ object (PySide6.QtGui.QHideEvent) already deleted.")
    # AttributeError("'LoadingIndicator' object has no attribute 'timer'")
    "tests/tests_gui/test_loading_indicator.py"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # requires a display
    "tests/integration/test_normcap.py"
    "tests/integration/test_tray_menu.py"
    "tests/integration/test_settings_menu.py"
    "tests/tests_clipboard/test_handlers/test_qtclipboard.py"
    "tests/tests_gui/test_tray.py"
    "tests/tests_gui/test_window.py"
    "tests/tests_screengrab/"
    # failure unknown, crashes in first test with `.show()`
    "tests/tests_gui/test_loading_indicator.py"
    "tests/tests_gui/test_menu_button.py"
    "tests/tests_gui/test_resources.py"
    "tests/tests_gui/test_update_check.py"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "com.github.dynobo.normcap";
      desktopName = "NormCap";
      genericName = "OCR powered screen-capture tool";
      comment = "Extract text from an image directly into clipboard";
      exec = "normcap";
      icon = "normcap";
      terminal = false;
      categories = ["Utility" "Office"];
      keywords = ["Text" "Extraction" "OCR"];
    })
  ];

  meta = with lib; {
    description = "OCR powered screen-capture tool to capture information instead of images";
    homepage = "https://dynobo.github.io/normcap/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cafkafk pbsds ];
    mainProgram = "normcap";
  };
}
