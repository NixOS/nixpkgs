{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, kwallet, kcmutils, knotifyconfig, ktexteditor, kidentitymanagement,
  kldap, kmailtransport, pimcommon, libkleo, kross
}:

let
  unwrapped =
    kdeApp {
      name = "kmail-account-wizard";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        akonadi kwallet kcmutils knotifyconfig ktexteditor kidentitymanagement
        kldap kmailtransport pimcommon libkleo kross
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/accountwizard" ];
}
