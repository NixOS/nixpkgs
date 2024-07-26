{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, libkdegames }:

mkDerivation {
  pname = "kapman";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kapman";
    description = "Clone of the well known game Pac-Man";
    mainProgram = "kapman";
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
