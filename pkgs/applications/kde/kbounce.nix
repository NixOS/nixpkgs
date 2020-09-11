{ mkDerivation, lib, extra-cmake-modules, libkdegames, kconfig, kcrash, kio, ki18n }:

mkDerivation {
  name = "kbounce";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kbounce";
    description = "KBounce is a single player arcade game with the elements of puzzle";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    kconfig
    kcrash
    kio
    ki18n
  ];
}
