{ mkDerivation, lib
, libkdegames, extra-cmake-modules
, kdeclarative, knewstuff
}:

mkDerivation {
  pname = "bovo";
  meta = with lib; {
    homepage = "https://apps.kde.org/bovo/";
    description = "Five in a row application";
    mainProgram = "bovo";
    longDescription = ''
      Bovo is a Gomoku (from Japanese 五目並べ - lit. "five points") like game for two players,
      where the opponents alternate in placing their respective pictogram on the game board.
      (Also known as: Connect Five, Five in a row, X and O, Naughts and Crosses)
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
