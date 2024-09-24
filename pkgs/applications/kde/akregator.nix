{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  qtwebengine,
  grantlee,
  kcmutils, kcrash, kiconthemes, knotifyconfig, kparts, ktexteditor,
  kuserfeedback,
  kwindowsystem,
  akonadi, akonadi-mime, grantleetheme, kontactinterface, libkdepim, libkleo,
  messagelib, syndication
}:

mkDerivation {
  pname = "akregator";
  meta = {
    homepage = "https://apps.kde.org/akregator/";
    description = "KDE feed reader";
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    qtwebengine

    grantlee

    kcmutils kcrash kiconthemes knotifyconfig kparts ktexteditor
    kuserfeedback
    kwindowsystem

    akonadi akonadi-mime grantleetheme kontactinterface libkdepim libkleo
    messagelib syndication
  ];
  outputs = [ "out" "dev" ];
}
