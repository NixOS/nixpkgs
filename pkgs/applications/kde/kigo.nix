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
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kigo";
    description = "An open-source implementation of the popular Go game";
    mainProgram = "kigo";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
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
