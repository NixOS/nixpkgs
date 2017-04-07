{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kbookmarks, kcalutils, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kdelibs4support, kguiaddons, ki18n, kiconthemes, kinit, kio, knotifications,
  knotifyconfig, kparts, kpty, kservice, ktextwidgets, ktnef, kwidgetsaddons,
  kwindowsystem, kxmlgui, libksieve, mailcommon, messagelib, qtscript,
  qtwebengine
}:

let
  unwrapped =
    kdeApp {
      name = "kmail";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        kbookmarks kcalutils kcompletion kconfig kconfigwidgets kcoreaddons
        kdelibs4support kguiaddons ki18n kiconthemes kinit kio knotifications
        knotifyconfig kparts kpty kservice ktextwidgets ktnef kwidgetsaddons
        kwindowsystem kxmlgui libksieve mailcommon messagelib qtscript
        qtwebengine
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kmail" ];
}
