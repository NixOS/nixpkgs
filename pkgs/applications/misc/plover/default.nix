{
  lib,
  config,
  stdenv,
  buildPythonPackage ? python3Packages.buildPythonPackage,
  fetchFromGitHub,
  versionCheckHook,
  python3Packages,
  libsForQt5,
}:

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

      build-system = with python3Packages; [
        babel
        setuptools
        pyqt5
        wheel
      ];
      dependencies = with python3Packages; [
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
      nativeBuildInputs = with libsForQt5; [
        wrapQtAppsHook
      ];

      nativeCheckInputs = with python3Packages; [
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

      meta = with lib; {
        broken = stdenv.hostPlatform.isDarwin;
        description = "OpenSteno Plover stenography software";
        maintainers = with maintainers; [
          twey
          kovirobi
        ];
        license = licenses.gpl2;
      };
    }
  );
}
// lib.optionalAttrs config.allowAliases {
  stable = throw "plover.stable was removed because it used Python 2. Use plover.dev instead."; # added 2022-06-05
}
