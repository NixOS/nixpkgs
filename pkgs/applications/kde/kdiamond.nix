{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  libkdegames,
  kconfig,
  knotifyconfig,
}:

mkDerivation {
  pname = "kdiamond";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.kdiamond";
    description = "Single player puzzle game";
    mainProgram = "kdiamond";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
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
