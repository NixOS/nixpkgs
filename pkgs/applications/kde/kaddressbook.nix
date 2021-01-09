{
  mkDerivation, lib, kdepimTeam, fetchpatch,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-search, grantlee, grantleetheme, kcmutils, kcompletion,
  kcrash, kdbusaddons, kdepim-apps-libs, ki18n, kontactinterface, kparts,
  kpimtextedit, kxmlgui, libkdepim, libkleo, mailcommon, pimcommon, prison,
  qgpgme, qtbase,
}:

mkDerivation {
  pname = "kaddressbook";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  patches = [
    # Patch for Qt 5.15.2 until version 20.12.0
    (fetchpatch {
      url = "https://invent.kde.org/pim/kaddressbook/-/commit/8aee8d40ae2a1c920d3520163d550d3b49720226.patch";
      sha256 = "sha256:0dsy119cd5w9khiwgk6fb7xnjzmj94rfphf327k331lf15zq4853";
    })
  ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-search grantlee grantleetheme kcmutils kcompletion kcrash
    kdbusaddons kdepim-apps-libs ki18n kontactinterface kparts kpimtextedit
    kxmlgui libkdepim libkleo mailcommon pimcommon prison qgpgme qtbase
  ];
}
