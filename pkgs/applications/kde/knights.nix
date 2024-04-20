{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, kplotting, plasma-framework, libkdegames }:

mkDerivation {
  pname = "knights";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.knights";
    description = "A chess game";
    mainProgram = "knights";
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
