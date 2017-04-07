{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, kcmutils, kdbusaddons, kontactinterface, kpimtextedit, libkleo,
  mailcommon
}:

let
  unwrapped =
    kdeApp {
      name = "kaddressbook";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        akonadi kcmutils kdbusaddons kontactinterface kpimtextedit libkleo
        mailcommon
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kaddressbook" ];
}
