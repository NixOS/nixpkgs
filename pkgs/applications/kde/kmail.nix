{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi-search, kbookmarks, kcalutils, kcmutils, kcompletion, kconfig,
  kconfigwidgets, kcoreaddons, kdelibs4support, kdepim-apps-libs, libkdepim,
  kdepim-runtime, kguiaddons, ki18n, kiconthemes, kinit, kio, kldap,
  kmail-account-wizard, kmailtransport, knotifications, knotifyconfig,
  kontactinterface, kparts, kpty, kservice, ktextwidgets, ktnef, kwallet,
  kwidgetsaddons, kwindowsystem, kxmlgui, libgravatar, libksieve, mailcommon,
  messagelib, pim-sieve-editor, qtscript, qtwebengine, akonadi, kdepim-addons
}:

mkDerivation {
  name = "kmail";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi-search kbookmarks kcalutils kcmutils kcompletion kconfig
    kconfigwidgets kcoreaddons kdelibs4support kdepim-apps-libs kguiaddons ki18n
    kiconthemes kinit kio kldap kmail-account-wizard kmailtransport libkdepim
    knotifications knotifyconfig kontactinterface kparts kpty kservice
    ktextwidgets ktnef kwidgetsaddons kwindowsystem kxmlgui libgravatar
    libksieve mailcommon messagelib pim-sieve-editor qtscript qtwebengine
    kdepim-addons
  ];
  propagatedUserEnvPkgs = [ kdepim-runtime kwallet akonadi ];
  patches = [ ./kmail.patch ];
}
