{ mkDerivation, lib, extra-cmake-modules, kdoctools, kxmlgui, kio, knotifications, libkdegames, shared-mime-info }:

mkDerivation {
  name = "palapeli";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/palapeli";
    description = "A single-player jigsaw puzzle game";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info
  ];
  buildInputs = [
    kdoctools
    kio
    knotifications
    kxmlgui
    libkdegames
  ];
}
