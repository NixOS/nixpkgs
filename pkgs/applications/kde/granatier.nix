{
  mkDerivation,
  lib,
  libkdegames,
  extra-cmake-modules,
  kdeclarative,
  knewstuff,
}:

mkDerivation {
  pname = "granatier";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.granatier";
    description = "Clone of the classic Bomberman game";
    mainProgram = "granatier";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdeclarative
    knewstuff
    libkdegames
  ];
}
