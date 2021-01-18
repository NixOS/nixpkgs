{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, libkdegames, libkmahjongg }:

mkDerivation {
  pname = "kshisen";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kshisen";
    description = "A solitaire-like game played using the standard set of Mahjong tiles";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    libkmahjongg
    kdoctools
    ki18n
    kio
  ];
}
