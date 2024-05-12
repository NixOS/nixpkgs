{ lib
, stdenv
, python3
, fetchFromGitHub
, tesseract4
, leptonica
, wl-clipboard
, libnotify
, xorg
}:

let

  ps = python3.pkgs;

  wrapperDeps = [
    leptonica
    tesseract4
    libnotify
  ] ++ lib.optionals stdenv.isLinux [
    wl-clipboard
  ];

in

ps.buildPythonApplication rec {
  pname = "normcap";
  version = "0.5.6";
  format = "pyproject";

  disabled = ps.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dynobo";
    repo = "normcap";
    rev = "refs/tags/v${version}";
    hash = "sha256-pvctgJCst536D3yLlel70hCwe1T3lxA8F6L3KKbfiEA=";
  };

  postPatch = ''
    # disable coverage testing
    substituteInPlace pyproject.toml \
      --replace-fail "addopts = [" "addopts_ = ["
  '';

  pythonRemoveDeps = [
    "pyside6-essentials"
  ];

  pythonRelaxDeps = [
    "shiboken6"
  ];

  nativeBuildInputs = [
    ps.pythonRelaxDepsHook
    ps.hatchling
    ps.babel
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

  nativeCheckInputs = wrapperDeps ++ [
    ps.pytestCheckHook
    ps.pytest-qt
    ps.toml
  ] ++ lib.optionals stdenv.isLinux [
    ps.pytest-xvfb
    xorg.xorgserver
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '' + lib.optionalString stdenv.isLinux ''
    # setup a virtual x11 display
    export DISPLAY=:$((2000 + $RANDOM % 1000))
    Xvfb $DISPLAY -screen 5 1024x768x8 &
    xvfb_pid=$!
  '';

  postCheck = lib.optionalString stdenv.isLinux ''
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
  ] ++ lib.optionals stdenv.isDarwin [
    # requires impure pbcopy
    "test_get_copy_func_with_pbcopy"
    "test_get_copy_func_without_pbcopy"
    "test_perform_pbcopy"
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
  ] ++ lib.optionals stdenv.isDarwin [
    # requires a display
    "tests/integration/test_normcap.py"
    "tests/integration/test_tray_menu.py"
    # failure unknown, crashes in first test with `.show()`
    "tests/tests_gui/test_loading_indicator.py"
  ];

  meta = with lib; {
    description = "OCR powered screen-capture tool to capture information instead of images";
    homepage = "https://dynobo.github.io/normcap/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cafkafk pbsds ];
    mainProgram = "normcap";
    broken = stdenv.isDarwin;
  };
}
