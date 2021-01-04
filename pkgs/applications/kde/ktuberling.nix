{ mkDerivation, lib, extra-cmake-modules, kdoctools, kio, kxmlgui, libkdegames, qtmultimedia }:

mkDerivation {
  name = "ktuberling";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/ktuberling";
    description = "A simple constructor game suitable for children and adults alike";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kio
    kxmlgui
    libkdegames
    qtmultimedia
  ];
}
