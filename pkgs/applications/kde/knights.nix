{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, kplotting, plasma-framework, libkdegames }:

mkDerivation {
  name = "knights";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.knights";
    description = "KNights is a chess game";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    plasma-framework
    kplotting
    kdoctools
    ki18n
    kio
  ];
}
