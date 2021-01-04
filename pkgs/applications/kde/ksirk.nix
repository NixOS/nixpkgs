{ mkDerivation, lib, extra-cmake-modules, kdoctools, kxmlgui, knewstuff, libkdegames, phonon, qca-qt5 }:

mkDerivation {
  name = "ksirk";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/ksirk";
    description = "Computerized version of the well known strategic board game Risk";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    knewstuff
    kxmlgui
    libkdegames
    phonon
    qca-qt5
  ];
}
