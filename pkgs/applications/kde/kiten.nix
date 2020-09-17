{ mkDerivation, lib, extra-cmake-modules, kdoctools, kxmlgui, kio, knotifications }:

mkDerivation {
  name = "kiten";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kiten";
    description = "A Japanese reference and study tool";
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
    kxmlgui
  ];
}
