{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kconfig, kcrash, kiconthemes, knotifyconfig }:

mkDerivation {
  pname = "kteatime";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/utilities/org.kde.kteatime";
    description = "Handy timer for steeping tea";
    mainProgram = "kteatime";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    ki18n
    kconfig
    kcrash
    kiconthemes
    knotifyconfig
  ];
}
