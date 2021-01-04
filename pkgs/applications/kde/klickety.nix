{ mkDerivation, lib, extra-cmake-modules, kdoctools, libkdegames, kxmlgui, kio }:

mkDerivation {
  name = "klickety";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/klickety";
    description = "Strategy game, an adaption of the Clickomania game";
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
    kio
    kxmlgui
  ];
}
