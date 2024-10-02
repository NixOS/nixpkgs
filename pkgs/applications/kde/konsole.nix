{
  mkDerivation, lib, nixosTests,
  extra-cmake-modules, kdoctools,
  kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kguiaddons,
  ki18n, kiconthemes, kinit, kio, knotifications,
  knotifyconfig, kparts, kpty, kservice, ktextwidgets, kwidgetsaddons,
  kwindowsystem, kxmlgui, qtscript, knewstuff, qtmultimedia
}:

mkDerivation {
  pname = "konsole";
  meta = {
    homepage = "https://apps.kde.org/konsole/";
    description = "KDE terminal emulator";
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = with lib.maintainers; [ ttuegel ];
    mainProgram = "konsole";
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kbookmarks kcompletion kconfig kconfigwidgets kcoreaddons
    kguiaddons ki18n kiconthemes kinit kio knotifications knotifyconfig kparts kpty
    kservice ktextwidgets kwidgetsaddons kwindowsystem kxmlgui qtscript knewstuff qtmultimedia
  ];

  passthru.tests.test = nixosTests.terminal-emulators.konsole;

  propagatedUserEnvPkgs = [ (lib.getBin kinit) ];
}
