{
  mkDerivation,
  lib,
  cmake,
  extra-cmake-modules,
  threadweaver,
  ktexteditor,
  kdevelop-unwrapped,
  python39,
}:
let
  # FIXME: stick with python 3.9 until MR supporting 3.10 is ready:
  # https://invent.kde.org/kdevelop/kdev-python/-/merge_requests/16
  python = python39;
in
mkDerivation rec {
  pname = "kdev-python";

  cmakeFlags = [
    "-DPYTHON_EXECUTABLE=${python}/bin/python"
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
