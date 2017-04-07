{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, akonadi-notes,
  kalarmcal, kcalutils, kcontacts, kdelibs4support, kidentitymanagement, kimap,
  kmailtransport, kmbox, kmime, knotifyconfig, kross, qtwebengine,
  shared_mime_info
}:

let
  unwrapped =
    kdeApp {
      name = "kdepim-runtime";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        akonadi akonadi-calendar akonadi-contacts akonadi-mime akonadi-notes
        kalarmcal kcalutils kcontacts kdelibs4support kidentitymanagement
        kimap kmime kmailtransport kmbox knotifyconfig kross qtwebengine
        shared_mime_info
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ ];
}
