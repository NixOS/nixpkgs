{ mkDerivation, lib, fetchpatch
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

  patches = [
    # fix compile error due to usage of deprecated things
    # probably can be removed with the next kde bump
    (fetchpatch {
      url = "https://invent.kde.org/games/picmi/-/commit/99639fb499fe35eb463621efca1c0e4ff2a52bad.patch";
      revert = true;
      sha256 = "sha256-rRhTvUB1Hpc3bLv9b5yIf/G7uJy2/OgBfXToZwV4jrg=";
    })
  ];

  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdeclarative
    knewstuff
    libkdegames
  ];
}
