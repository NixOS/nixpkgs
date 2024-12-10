{
  mkDerivation,
  lib,
  extra-cmake-modules,
  libkdegames,
  kconfig,
  kcrash,
  kdoctools,
  ki18n,
  kio,
}:

mkDerivation {
  pname = "kmines";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kmines";
    description = "A classic Minesweeper game";
    mainProgram = "kmines";
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
