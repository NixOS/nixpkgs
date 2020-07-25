{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, libkdegames, knewstuff }:

mkDerivation {
  name = "kigo";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org/kde.kigo";
    description = "Kigo est une implémentation libre du jeu de Go";
    maintainers = with maintainers; [ freezeboy ];
    licence = licences.gpl2Plus;
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
