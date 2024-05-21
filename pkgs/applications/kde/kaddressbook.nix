{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-search, grantlee, grantleetheme, kcmutils, kcompletion,
  kcrash, kdbusaddons, ki18n, kontactinterface, kparts,
  kpimtextedit,
  kuserfeedback,
  kxmlgui, libkdepim, libkleo, mailcommon, pimcommon, prison,
  qgpgme, qtbase,
}:

mkDerivation {
  pname = "kaddressbook";
  meta = {
    homepage = "https://apps.kde.org/kaddressbook/";
    description = "KDE contact manager";
    mainProgram = "kaddressbook";
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-search grantlee grantleetheme kcmutils kcompletion kcrash
    kdbusaddons ki18n kontactinterface kparts kpimtextedit
    kuserfeedback
    kxmlgui libkdepim libkleo mailcommon pimcommon prison qgpgme qtbase
  ];
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$out/include/KF5"
  '';
}
