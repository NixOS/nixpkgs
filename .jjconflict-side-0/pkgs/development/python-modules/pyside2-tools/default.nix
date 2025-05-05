{
  wrapPython,
  python,
  lib,
  stdenv,
  cmake,
  qt5,
  distutils,
  shiboken2,
  pyside2,
}:

stdenv.mkDerivation {
  pname = "pyside2-tools";

  inherit (pyside2) version src;

  patches = [
    # Upstream has a crazy build system only geared towards producing binary
    # wheels distributed via pypi.  For this, they copy the `uic` and `rcc`
    # binaries to the wheel.
    ./remove_hacky_binary_copying.patch
  ];

  postPatch = ''
    cd sources/pyside2-tools
  '';

  nativeBuildInputs = [
    cmake
    distutils
    wrapPython
  ];
  propagatedBuildInputs = [
    shiboken2
    pyside2
  ];
  buildInputs = [
    python
    qt5.qtbase
  ];

  cmakeFlags = [ "-DBUILD_TESTS=OFF" ];

  dontWrapQtApps = true;

  # The upstream build system consists of a `setup.py` whichs builds three
  # different python libraries and calls cmake as a subprocess.  We call cmake
  # directly because that's easier to get working.  However, the `setup.py`
  # build also creates a few wrapper scripts, which we replicate here:
  postInstall = ''
    rm $out/bin/pyside_tool.py

    for tool in uic rcc; do
      makeWrapper "$(command -v $tool)" $out/bin/pyside2-$tool --add-flags "-g python"
    done
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "PySide2 development tools";
    license = licenses.gpl2;
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ ];
  };
}
