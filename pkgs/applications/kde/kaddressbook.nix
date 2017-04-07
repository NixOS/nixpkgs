{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-search, grantlee, grantleetheme, kcmutils, kcompletion,
  kcrash, kdbusaddons, kdepim-apps-libs, ki18n, kontactinterface, kparts,
  kpimtextedit, kxmlgui, libkdepim, libkleo, mailcommon, pimcommon, prison,
  qgpgme, qtbase,
}:

mkDerivation {
  name = "kaddressbook";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-search grantlee grantleetheme kcmutils kcompletion kcrash
    kdbusaddons kdepim-apps-libs ki18n kontactinterface kparts kpimtextedit
    kxmlgui libkdepim libkleo mailcommon pimcommon prison qgpgme qtbase
  ];
}
