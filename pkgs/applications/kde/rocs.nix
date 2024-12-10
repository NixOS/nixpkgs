{
  mkDerivation,
  lib,
  extra-cmake-modules,
  boost,
  qtbase,
  qtscript,
  qtquickcontrols,
  qtxmlpatterns,
  grantlee,
  kdoctools,
  karchive,
  kxmlgui,
  kcrash,
  kdeclarative,
  ktexteditor,
  kguiaddons,
}:

mkDerivation {
  pname = "rocs";

  meta = with lib; {
    homepage = "https://edu.kde.org/rocs/";
    description = "A graph theory IDE.";
    mainProgram = "rocs";
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ knairda ];
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    boost
    qtbase
    qtscript
    qtquickcontrols
    qtxmlpatterns
    grantlee
    kxmlgui
    kcrash
    kdeclarative
    karchive
    ktexteditor
    kguiaddons
  ];
}
