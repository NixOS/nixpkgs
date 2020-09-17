{ mkDerivation, lib, extra-cmake-modules, kdoctools, qtwebengine, kxmlgui, kcoreaddons, kparts }:

mkDerivation {
  name = "kimagemapeditor";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kimagemapeditor";
    description = "editor of image maps embedded inside HTML files";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    qtwebengine
    kcoreaddons
    kparts
    kxmlgui
  ];
}
