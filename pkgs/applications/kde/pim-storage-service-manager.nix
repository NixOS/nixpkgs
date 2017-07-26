{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kdbusaddons, knotifyconfig, kpimtextedit, kxmlgui, libkdepim, pimcommon
}:

let
  unwrapped =
    kdeApp {
      name = "pim-storage-service-manager";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        kdbusaddons knotifyconfig kpimtextedit kxmlgui libkdepim pimcommon
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/storageservicemanager" ];
}
