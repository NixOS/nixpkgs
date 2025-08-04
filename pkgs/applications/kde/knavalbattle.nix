{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  libkdegames,
  kdnssd,
}:

mkDerivation {
  pname = "knavalbattle";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.knavalbattle";
    description = "Naval Battle is a ship sinking game";
    mainProgram = "knavalbattle";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    kdoctools
    ki18n
    kio
    kdnssd
  ];
}
