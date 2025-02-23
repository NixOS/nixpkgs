{
  lib,
  fetchFromGitHub,
  # Plover is currently tested with python 3.10 and do not seems to work with more recent versions
  # https://github.com/openstenoproject/plover/commits/a8ac3631bee1971eec2b41b74fbebdad4750291a
  python310Packages,
  qt5,
  dbus,
}:

{
  dev =
    let
      inherit (python310Packages)
        appdirs
        babel
        buildPythonPackage
        evdev
        pyqt5
        pyserial
        pytest-qt
        pytestCheckHook
        setuptools
        stdenv
        wcwidth
        xlib
        ;
      inherit (lib) licenses maintainers platforms;
      plover_stroke = buildPythonPackage rec {
        pname = "plover_stroke";
        version = "1.1.0";

        pyproject = true;

        src = fetchFromGitHub {
          owner = "openstenoproject";
          repo = "plover_stroke";
          rev = "refs/tags/${version}";
          sha256 = "sha256-A75OMzmEn0VmDAvmQCp6/7uptxzwWJTwsih3kWlYioA=";
        };

        propagatedBuildInputs = [ setuptools ];

        nativeCheckInputs = [ pytestCheckHook ];
        pythonImportsCheck = [ "plover_stroke" ];

        meta = {
          description = "Stroke handling helper library for Plover";
          license = licenses.gpl2Plus;
          homepage = "https://github.com/openstenoproject/plover_stroke";
          platforms = platforms.linux ++ platforms.windows;
          maintainers = [ maintainers.FirelightFlagboy ];
        };
      };

      rtf_tokenize = buildPythonPackage rec {
        pname = "rtf_tokenize";
        version = "1.0.0";

        pyproject = true;

        src = fetchFromGitHub {
          owner = "openstenoproject";
          repo = "rtf_tokenize";
          rev = "refs/tags/${version}";
          sha256 = "sha256-zwD2sRYTY1Kmm/Ag2hps9VRdUyQoi4zKtDPR+F52t9A=";
        };

        propagatedBuildInputs = [ setuptools ];

        nativeCheckInputs = [ pytestCheckHook ];
        pythonImportsCheck = [ "rtf_tokenize" ];

        meta = {
          description = "Simple RTF tokenizer";
          license = licenses.gpl2Plus;
          homepage = "https://github.com/openstenoproject/rtf_tokenize";
          platforms = platforms.linux ++ platforms.windows;
          maintainers = [ maintainers.FirelightFlagboy ];
        };
      };
    in
    buildPythonPackage rec {
      pname = "plover";
      version = "4.0.0";

      pyproject = true;

      src = fetchFromGitHub {
        owner = "openstenoproject";
        repo = "plover";
        rev = "refs/tags/v${version}";
        sha256 = "sha256-9oDsAbpF8YbLZyRzj9j5tk8QGi0o1F+8vB5YLJGqN+4=";
      };

      postPatch = ''
        # Plover dynamically loads the dbus library
        substituteInPlace plover/oslayer/linux/log_dbus.py \
          --replace-fail "ctypes.util.find_library('dbus-1')" "'${dbus.lib}/lib/libdbus-1.so'"
      '';

      nativeBuildInputs = [
        setuptools
        qt5.wrapQtAppsHook
      ];

      propagatedBuildInputs = [
        appdirs
        babel
        evdev
        plover_stroke
        pyqt5
        pyserial
        rtf_tokenize
        setuptools
        wcwidth
        xlib
      ];

      buildInputs = [
        qt5.qtwayland
      ];

      nativeCheckInputs = [
        pytestCheckHook
        pytest-qt
      ];

      preCheck = ''
        export HOME=$(mktemp -d)
        export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
        export QT_QPA_PLATFORM_PLUGIN_PATH="${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
        export QT_QPA_PLATFORM=offscreen
      '';

      dontWrapQtApps = true;

      preFixup = ''
        makeWrapperArgs+=("''${qtWrapperArgs[@]}")
      '';

      meta = {
        mainProgram = "plover";
        broken = stdenv.hostPlatform.isDarwin;
        description = "OpenSteno Plover stenography software";
        homepage = "https://www.openstenoproject.org/plover/";
        maintainers = builtins.attrValues {
          inherit (maintainers) FirelightFlagboy twey kovirobi;
        };
        license = licenses.gpl2Plus;
      };
    };
}
