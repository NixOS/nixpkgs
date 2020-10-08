{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, libkdegames }:

mkDerivation {
  name = "kblocks";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kblocks";
    description = "KBlocks is the classic falling blocks game";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    kdoctools
    ki18n
    kio
  ];
}
