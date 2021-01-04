{ mkDerivation, lib, extra-cmake-modules, kdoctools, kio, knotifications, kross, kxmlgui, hunspell }:

mkDerivation {
  name = "lokalize";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/lokalize";
    description = "Localization tool for KDE software and other free and open source software";
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
    kross
    kxmlgui
    hunspell
  ];
}
