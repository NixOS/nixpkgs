{ mkDerivation, lib, extra-cmake-modules, kdoctools, kxmlgui, knotifications, phonon, libXt, libXtst }:

mkDerivation {
  name = "kmousetool";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kmousetool";
    description = "Clicks the mouse for you, so you don't have to";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    knotifications
    kxmlgui
    libXtst
    libXt
    phonon
  ];
}
