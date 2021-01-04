{ mkDerivation, lib, extra-cmake-modules, kdoctools, libkdegames, kxmlgui, kio }:

mkDerivation {
  name = "kjumpingcube";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kjumpingcube";
    description = "A simple dice driven tactical game";
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
    kxmlgui
    kio
  ];
}
