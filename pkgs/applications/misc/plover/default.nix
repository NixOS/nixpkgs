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
