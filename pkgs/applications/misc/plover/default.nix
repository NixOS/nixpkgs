{
  lib,
  config,
  stdenv,
  plover,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
  python3Packages,
  libsForQt5,
}:

let
  buildPythonPackage = python3Packages.buildPythonPackage;
  wrapQtAppsHook = libsForQt5.wrapQtAppsHook;
  appdirs = python3Packages.appdirs;
  babel = python3Packages.babel;
  evdev = python3Packages.evdev;
  mock = python3Packages.mock;
  pyqt5 = python3Packages.pyqt5;
  pyserial = python3Packages.pyserial;
  pytestCheckHook = python3Packages.pytestCheckHook;
  pytest-qt = python3Packages.pytest-qt;
  plover-stroke = python3Packages.plover-stroke;
  rtf-tokenize = python3Packages.rtf-tokenize;
  setuptools = python3Packages.setuptools;
  wcwidth = python3Packages.wcwidth;
  wheel = python3Packages.wheel;
  xlib = python3Packages.xlib;
in
{
  dev = (
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
  );
}
// lib.optionalAttrs config.allowAliases {
  stable = throw "plover.stable was removed because it used Python 2. Use plover.dev instead."; # added 2022-06-05
}
