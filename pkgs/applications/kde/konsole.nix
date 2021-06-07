{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kguiaddons,
  ki18n, kiconthemes, kinit, kio, knotifications,
  knotifyconfig, kparts, kpty, kservice, ktextwidgets, kwidgetsaddons,
  kwindowsystem, kxmlgui, qtscript, knewstuff
}:

mkDerivation {
  pname = "konsole";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = with lib.maintainers; [ ttuegel turion ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kbookmarks kcompletion kconfig kconfigwidgets kcoreaddons
    kguiaddons ki18n kiconthemes kinit kio knotifications knotifyconfig kparts kpty
    kservice ktextwidgets kwidgetsaddons kwindowsystem kxmlgui qtscript knewstuff
  ];

  propagatedUserEnvPkgs = [ (lib.getBin kinit) ];
}
