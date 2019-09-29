{
  mkDerivation, lib,
  extra-cmake-modules, boost,
  qtbase, qtscript, qtquickcontrols, qtwebkit, qtxmlpatterns, grantlee,
  kdoctools, karchive, kxmlgui, kcrash, kdeclarative, ktexteditor, kguiaddons
}:

mkDerivation {
  name = "rocs";

  meta = with lib; {
    homepage = "https://edu.kde.org/rocs/";
    description = "A graph theory IDE.";
    license = with licenses; [ gpl2 lgpl21 fdl12 ];
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ knairda ];
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    boost
    qtbase qtscript qtquickcontrols qtwebkit qtxmlpatterns grantlee
    kxmlgui kcrash kdeclarative karchive ktexteditor kguiaddons
  ];
}
