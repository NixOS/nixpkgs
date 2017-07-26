{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, calendarsupport, kcalcore, kcompletion,
  kconfigwidgets, kcontacts, kdbusaddons, kitemmodels, kpimtextedit,
  ktextwidgets, kxmlgui, messagelib
}:

let
  unwrapped =
    kdeApp {
      name = "akonadiconsole";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        akonadi akonadi-contacts calendarsupport kcalcore kcompletion
        kconfigwidgets kcontacts kdbusaddons kitemmodels kpimtextedit
        ktextwidgets kxmlgui messagelib
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/akonadiconsole" ];
}
