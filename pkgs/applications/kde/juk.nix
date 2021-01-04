{ mkDerivation, lib, extra-cmake-modules, kdoctools, phonon, kxmlgui, kio, kwallet, knotifications, taglib }:

mkDerivation {
  name = "juk";
  meta = with lib; {
    homepage = "https://juk.kde.org";
    description = "Music player and a music manager";
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
    knotifications
    kwallet
    kxmlgui
    phonon
    taglib
  ];
}
