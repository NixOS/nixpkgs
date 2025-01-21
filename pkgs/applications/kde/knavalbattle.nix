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
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.knavalbattle";
    description = "Naval Battle is a ship sinking game";
    mainProgram = "knavalbattle";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
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
