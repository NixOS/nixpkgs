{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt6,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "openmotor";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reilleya";
    repo = "openMotor";
    tag = "v${version}";
    hash = "sha256-5b/Q/qjd2EH+OG6pAZhPTnEnFy0e/reBH8sIH0DZORo=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  build-system = with python3Packages; [
    setuptools
    cython
  ];

  dependencies = with python3Packages; [
    cycler
    decorator
    ezdxf
    imageio
    matplotlib
    networkx
    numpy
    pillow
    platformdirs
    pyparsing
    pyqt6
    pyqt6-sip
    python-dateutil
    pyyaml
    scikit-fmm
    scikit-image
    scipy
    six
  ];

  postPatch = ''
        # The setup.py tries to import from uilib.fileIO to get version
        # This triggers logger initialization that tries to write to $HOME
        substituteInPlace setup.py \
          --replace-fail "try:
        from uilib.fileIO import appVersionStr
    except ImportError:
        print('App version not available, defaulting to 0.0.0')
        appVersionStr = '0.0.0'" \
            "appVersionStr = '${version}'"

        # Add entry_points and py_modules to setup.py to create executable
        substituteInPlace setup.py \
          --replace-fail "    packages=find_packages()," \
            "    packages=find_packages(),
        py_modules=['main', 'app'],"

        substituteInPlace setup.py \
          --replace-fail "    cmdclass=cmdclass" \
            "    cmdclass=cmdclass,
        entry_points={'console_scripts': ['openMotor=main:main']},"

        # Add main() function wrapper to main.py
        substituteInPlace main.py \
          --replace-fail "import sys
    from app import App
    from PyQt6.QtCore import Qt

    app = App(sys.argv)
    sys.exit(app.exec())" \
            "import sys
    from app import App
    from PyQt6.QtCore import Qt

    def main():
        app = App(sys.argv)
        sys.exit(app.exec())

    if __name__ == '__main__':
        main()"
  '';

  preBuild = ''
    # Compile Qt Designer .ui files to Python modules
    # UI files are in uilib/views/forms/ but output should be in uilib/views/
    for ui in $(find uilib/views/forms -name "*.ui" 2>/dev/null || true); do
      base=$(basename "$ui" .ui)
      py="uilib/views/''${base}_ui.py"
      echo "Compiling $ui -> $py"
      ${python3Packages.pyqt6}/bin/pyuic6 -o "$py" "$ui"
    done

    # Ensure views directory has __init__.py
    touch uilib/views/__init__.py
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  # Tests require additional setup and data files
  doCheck = false;

  pythonImportsCheck = [
    "motorlib"
    "uilib"
  ];

  meta = {
    description = "Open-source internal ballistics simulator for rocket motor experimenters";
    longDescription = ''
      openMotor is an open-source internal ballistics simulator for rocket motor
      experimenters. The software estimates a rocket motor's chamber pressure and
      thrust based on propellant properties, grain geometry, and nozzle specifications.
      It uses the Fast Marching Method to determine how a propellant grain regresses,
      which allows the use of arbitrary core geometries.
    '';
    homepage = "https://github.com/reilleya/openMotor";
    changelog = "https://github.com/reilleya/openMotor/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vikingnope ];
    platforms = lib.platforms.unix;
    mainProgram = "openMotor";
  };
}
