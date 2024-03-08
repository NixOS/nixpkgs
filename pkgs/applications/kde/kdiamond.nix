{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, libkdegames, kconfig, knotifyconfig }:

mkDerivation {
  pname = "kdiamond";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kdiamond";
    description = "A single player puzzle game";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    knotifyconfig
    kconfig
    kdoctools
    ki18n
    kio
  ];
}
