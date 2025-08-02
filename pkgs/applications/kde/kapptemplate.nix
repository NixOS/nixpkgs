{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  qtbase,
  kactivities,
}:
mkDerivation {

  pname = "kapptemplate";

  nativeBuildInputs = [
    extra-cmake-modules
    cmake
  ];

  buildInputs = [
    kactivities
    qtbase
  ];

  meta = {
    description = "KDE App Code Template Generator";
    mainProgram = "kapptemplate";
    license = lib.licenses.gpl2;
    homepage = "https://kde.org/applications/en/development/org.kde.kapptemplate";
    maintainers = [ lib.maintainers.shamilton ];
    platforms = lib.platforms.linux;
  };
}
