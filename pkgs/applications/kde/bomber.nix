{ mkDerivation, lib
, libkdegames, extra-cmake-modules
, kdeclarative, knewstuff
}:

mkDerivation {
  name = "bomber";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.bomber";
    description = "Bomber is a single player arcade game";
    longDescription = ''
      Bomber is a single player arcade game. The player is invading various
      cities in a plane that is decreasing in height.

      The goal of the game is to destroy all the buildings and advance to the next level.
      Each level gets a bit harder by increasing the speed of the plane and the height of the buildings.
      '';
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
