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
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.kmines";
    description = "Classic Minesweeper game";
    mainProgram = "kmines";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
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
