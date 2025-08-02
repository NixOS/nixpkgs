{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  libkdegames,
  knewstuff,
}:

mkDerivation {
  pname = "kigo";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.kigo";
    description = "Open-source implementation of the popular Go game";
    mainProgram = "kigo";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    knewstuff
    kdoctools
    ki18n
    kio
  ];
}
