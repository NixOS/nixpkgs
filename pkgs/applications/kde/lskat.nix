{ mkDerivation, lib, extra-cmake-modules, kdoctools, kxmlgui, libkdegames }:

mkDerivation {
  name = "lskat";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/lskat";
    description = "Lieutenant Skat is a fun and engaging card game for two player";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kxmlgui
    libkdegames
  ];
}
