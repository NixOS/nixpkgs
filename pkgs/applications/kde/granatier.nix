{ mkDerivation, lib
, libkdegames, extra-cmake-modules
, kdeclarative, knewstuff
}:

mkDerivation {
  pname = "granatier";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.granatier";
    description = "Clone of the classic Bomberman game";
    mainProgram = "granatier";
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
