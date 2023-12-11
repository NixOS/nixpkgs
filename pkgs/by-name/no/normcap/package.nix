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
  version = "0.4.4";
  format = "pyproject";

  disabled = ps.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dynobo";
    repo = "normcap";
    rev = "refs/tags/v${version}";
    hash = "sha256-dShtmoqS9TC3PHuwq24OEOhYfBHGhDCma8Du8QCkFuI=";
  };

  pythonRemoveDeps = [
    "PySide6-Essentials"
  ];

  nativeBuildInputs = [
    ps.pythonRelaxDepsHook
    ps.poetry-core
  ];

  propagatedBuildInputs = [
    ps.pyside6
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
    kill $xvfb_pid
  '';

  disabledTests = [
    # requires a wayland session (no xclip support)
    "test_wl_copy"
    # times out, unknown why
    "test_update_checker_triggers_checked_signal"
    # touches network
    "test_urls_reachable"
    # requires xdg
    "test_synchronized_capture"
  ] ++ lib.optionals stdenv.isDarwin [
    # requires impure pbcopy
    "test_get_copy_func_with_pbcopy"
    "test_get_copy_func_without_pbcopy"
    "test_perform_pbcopy"
  ];

  disabledTestPaths = [
    # touches network
    "tests/tests_gui/test_downloader.py"
    # fails to import, causes pytest to freeze
    "tests/tests_gui/test_language_manager.py"
  ] ++ lib.optionals stdenv.isDarwin [
    # requires a display
    "tests/integration/test_normcap.py"
  ];

  meta = with lib; {
    description = "OCR powered screen-capture tool to capture information instead of images";
    homepage = "https://dynobo.github.io/normcap/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cafkafk pbsds ];
    mainProgram = "normcap";
  };
}
