{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, grantlee5, grantleetheme, kcmutils, kcrash, knotifyconfig, kontactinterface, kparts, ktexteditor, libkdepim, libkleo, messagelib, qtwebengine, syndication
}:

let
  unwrapped =
    kdeApp {
      name = "akregator";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        akonadi akonadi-mime grantlee5 grantleetheme kcmutils kcrash knotifyconfig kontactinterface kparts ktexteditor libkdepim libkleo messagelib qtwebengine syndication
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/akregator" ];
}
