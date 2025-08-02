{
  mkDerivation,
  lib,
  cmake,
  extra-cmake-modules,
  threadweaver,
  ktexteditor,
  kdevelop-unwrapped,
  python3,
}:

mkDerivation {
  pname = "kdev-python";

  cmakeFlags = [
    "-DPYTHON_EXECUTABLE=${lib.getExe python3}"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    threadweaver
    ktexteditor
    kdevelop-unwrapped
  ];

  dontWrapQtApps = true;

  meta = {
    maintainers = [ lib.maintainers.aanderse ];
    platforms = lib.platforms.linux;
    description = "Python support for KDevelop";
    homepage = "https://www.kdevelop.org";
    license = [ lib.licenses.gpl2 ];
  };
}
