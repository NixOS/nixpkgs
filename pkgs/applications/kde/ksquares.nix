{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  libkdegames,
  kconfig,
  kcrash,
  kxmlgui,
}:

mkDerivation {
  pname = "ksquares";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.ksquares";
    description = "Game of Dots and Boxes";
    mainProgram = "ksquares";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
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
