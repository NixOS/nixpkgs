{ mkDerivation, lib, extra-cmake-modules, libkdegames, kconfig, kcrash, kdoctools, ki18n, kio }:

mkDerivation {
  name = "kmines";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kmines";
    description = "KMines is a classic Minesweeper game";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    kconfig
    kcrash
    kio
    kdoctools
    ki18n
  ];
}
