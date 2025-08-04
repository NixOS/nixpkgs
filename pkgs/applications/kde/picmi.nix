{
  mkDerivation,
  lib,
  libkdegames,
  extra-cmake-modules,
  kdeclarative,
  knewstuff,
}:

mkDerivation {
  pname = "picmi";
  meta = {
    homepage = "https://apps.kde.org/picmi/";
    description = "Nonogram game";
    mainProgram = "picmi";
    longDescription = ''
      The goal is to reveal the hidden pattern in the board by coloring or
      leaving blank the cells in a grid according to numbers given at the side of the grid.
    '';
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
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
