{ mkDerivation, lib
, libkdegames, extra-cmake-modules
, kdeclarative, knewstuff
}:

mkDerivation {
  name = "granatier";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.granatier";
    description = "Granatier is a clone of the classic Bomberman game";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
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
