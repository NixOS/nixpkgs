{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  libkdegames,
}:

mkDerivation {
  pname = "kblackbox";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kblackbox";
    description = "Game of hide and seek played on a grid of boxes";
    mainProgram = "kblackbox";
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
  ];
}
