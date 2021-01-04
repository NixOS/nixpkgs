{ mkDerivation, lib, extra-cmake-modules, kdoctools, grantlee, qtwebengine, kcrash, kdbusaddons, kxmlgui, ktexteditor, knewstuff, pimcommon, messagelib, kdepim-apps-libs }:

mkDerivation {
  name = "grantlee-editor";
  meta = with lib; {
    homepage = "https://github.com/KDE/grantlee-editor";
    description = "Utilities and tools to manage themes in KDE PIM applications";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kcrash
    kdbusaddons
    knewstuff
    ktexteditor
    kxmlgui
    grantlee
    pimcommon
    kdepim-apps-libs
    messagelib
    qtwebengine
  ];
}
