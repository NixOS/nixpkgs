{ python3Packages
, qtbase
, ghostscript
, wrapQtAppsHook
, lib
}:

python3Packages.buildPythonApplication rec {
  pname = "veusz";
  version = "3.3.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "4ClgYwiU21wHDve2q9cItSAVb9hbR2F+fJc8znGI8OA=";
  };

  nativeBuildInputs = [ wrapQtAppsHook python3Packages.sip ];

  buildInputs = [ qtbase ];

  # veusz is a script and not an ELF-executable, so wrapQtAppsHook will not wrap
  # it automatically -> we have to do it explicitly
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/veusz"
  '';

  # For some reason, if sip5 is found on the PATH, the option --sip-dir is
  # ignored in setupPyBuildFlags, see
  # https://github.com/veusz/veusz/blob/53b99dffa999f2bc41fdc5335d7797ae857c761f/pyqtdistutils.py#L292
  postPatch = ''
    substituteInPlace pyqtdistutils.py \
      --replace "'-I', pyqt5_include_dir," "'-I', '${python3Packages.pyqt5}/share/sip/PyQt5',"
    patchShebangs tests/runselftest.py
  '';

  # you can find these options at
  # https://github.com/veusz/veusz/blob/53b99dffa999f2bc41fdc5335d7797ae857c761f/pyqtdistutils.py#L71
  setupPyBuildFlags = [
    # --sip-dir does nothing here, but it should be the correct way to set the
    # sip_dir, so I'm leaving it here for future versions
    "--sip-dir=${python3Packages.pyqt5}/share/sip"
    "--qt-include-dir=${qtbase.dev}/include"
    # veusz tries to find a libinfix and fails without one
    # but we simply don't need a libinfix, so set it to empty here
    "--qt-libinfix="
  ];

  propagatedBuildInputs = with python3Packages; [
    numpy
    pyqt5
    # optional requirements:
    dbus-python
    h5py
    # astropy -- fails to build on master
    # optional TODO: add iminuit, pyemf and sampy
  ];

  installCheckPhase = ''
    wrapQtApp "tests/runselftest.py"
    QT_QPA_PLATFORM=minimal tests/runselftest.py
  '';

  meta = with lib; {
    description = "A scientific plotting and graphing program with a GUI";
    homepage = "https://veusz.github.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ laikq ];
  };
}
