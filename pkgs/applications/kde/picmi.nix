{ mkDerivation, lib
, libkdegames, extra-cmake-modules
, kdeclarative, knewstuff
}:

mkDerivation {
  pname = "picmi";
  meta = with lib; {
    homepage = "https://apps.kde.org/picmi/";
    description = "Nonogram game";
    longDescription = ''The goal is to reveal the hidden pattern in the board by coloring or
      leaving blank the cells in a grid according to numbers given at the side of the grid.
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
