{ mkDerivation, lib, extra-cmake-modules, kdoctools, libkdegames, kconfig, kcrash, kxmlgui }:

mkDerivation {
  name = "ksquares";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.ksquares";
    description = "KSquares is a game of Dots and Boxes";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    libkdegames
    kconfig
    kcrash
    kxmlgui
  ];
}
