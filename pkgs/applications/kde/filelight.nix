{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kio, kparts, kxmlgui, qtscript, solid
}:

let
  unwrapped =
    kdeApp {
      name = "filelight";
      meta = {
        license = with lib.licenses; [ gpl2 ];
        maintainers = with lib.maintainers; [ fridh vcunat ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        kio kparts kxmlgui qtscript solid
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/filelight" ];
}
