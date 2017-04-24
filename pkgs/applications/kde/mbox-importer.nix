{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kconfig, kservice, kio, akonadi, mailcommon, akonadi-search
}:

let
  unwrapped =
    kdeApp {
      name = "mbox-importer";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        kconfig kservice kio akonadi mailcommon akonadi-search
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/mboximporter" ];
}
