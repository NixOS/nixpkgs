{ mkDerivation, lib, extra-cmake-modules, kdoctools, kconfig, kxmlgui, kdnssd, libkdegames }:

mkDerivation {
  name = "kfourinline";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kfourinline";
    description = "Board game for two players based on the Connect-Four game";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kconfig
    kxmlgui
    kdnssd
    libkdegames
  ];
}
