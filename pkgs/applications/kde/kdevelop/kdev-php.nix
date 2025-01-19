{
  mkDerivation,
  lib,
  cmake,
  extra-cmake-modules,
  threadweaver,
  ktexteditor,
  kdevelop-unwrapped,
  kdevelop-pg-qt,
}:

mkDerivation rec {
  pname = "kdev-php";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    kdevelop-pg-qt
    threadweaver
    ktexteditor
    kdevelop-unwrapped
  ];

  dontWrapQtApps = true;

  meta = {
    maintainers = [ lib.maintainers.aanderse ];
    platforms = lib.platforms.linux;
    description = "PHP support for KDevelop";
    homepage = "https://www.kdevelop.org";
    license = [ lib.licenses.gpl2 ];
  };
}
