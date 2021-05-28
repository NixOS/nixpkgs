{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kconfig, kcrash, kiconthemes, knotifyconfig }:

mkDerivation {
  name = "kteatime";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/utilities/org.kde.kteatime";
    description = "KTeaTime is a handy timer for steeping tea";
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
