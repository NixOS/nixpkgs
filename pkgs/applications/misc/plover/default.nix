{
  lib,
  config,
  stdenv,
  plover,
  buildPythonPackage ? python3Packages.buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
  python3Packages,
  libsForQt5,
}:

let
  inherit (python3Packages)
    buildPythonPackage
    appdirs
    babel
    evdev
    mock
    pyqt5
    pyserial
    pytestCheckHook
    pytest-qt
    plover-stroke
    rtf-tokenize
    setuptools
    wcwidth
    wheel
    xlib
    ;
  inherit (libsForQt5)
    wrapQtAppsHook
    ;
in
buildPythonPackage rec {
  pname = "plover";
  version = "4.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "plover";
    tag = "v${version}";
    hash = "sha256-VpQT25bl8yPG4J9IwLkhSkBt31Y8BgPJdwa88WlreA8=";
  };

  postPatch = ''
    sed -i 's/,<77//g' pyproject.toml # pythonRelaxDepsHook doesn't work for this for some reason
  '';

  build-system = [
    babel
    setuptools
    pyqt5
    wheel
  ];
  dependencies = [
    appdirs
    evdev
    pyqt5
    pyserial
    plover-stroke
    rtf-tokenize
    setuptools
    wcwidth
    xlib
  ];
  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
    pytest-qt
    mock
  ];

  # Segfaults?!
  disabledTestPaths = [ "test/gui_qt/test_dictionaries_widget.py" ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  dontWrapQtApps = true;

  pythonImportsCheck = [ "plover" ];

  meta = {
    description = "OpenSteno Plover stenography software";
    homepage = "https://www.openstenoproject.org/plover/";
    mainProgram = "plover";
    maintainers = with lib.maintainers; [
      twey
      kovirobi
      pandapip1
    ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
// lib.optionalAttrs config.allowAliases {
  # TODO: After 26.05 branch-off, remove these aliases
  dev =
    if lib.versionOlder "25.05" lib.version then
      throw "plover.dev was renamed. Use plover-dev instead." # added 2025-06-05`
    else
      plover;
  stable = throw "plover.stable was renamed. Use plover instead."; # added 2022-06-05; updated 2025-06-27
}
