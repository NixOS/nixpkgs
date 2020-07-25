{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, libkdegames }:

mkDerivation {
  name = "kapman";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kapman";
    description = "Kapman is a clone of the well known game Pac-Man";
    maintainers = with maintainers; [ freezeboy ];
    licence = licences.gpl2Plus;
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
