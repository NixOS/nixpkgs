{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  qtwebengine,
  grantlee,
  kcmutils, kcrash, kiconthemes, knotifyconfig, kparts, ktexteditor,
  kwindowsystem,
  akonadi, akonadi-mime, grantleetheme, kontactinterface, libkdepim, libkleo,
  messagelib, syndication
}:

mkDerivation {
  name = "akregator";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    qtwebengine

    grantlee

    kcmutils kcrash kiconthemes knotifyconfig kparts ktexteditor kwindowsystem

    akonadi akonadi-mime grantleetheme kontactinterface libkdepim libkleo
    messagelib syndication
  ];
  outputs = [ "out" "dev" ];
}
