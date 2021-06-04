{ mkDerivation
, lib
, akonadi
, akonadi-search
, extra-cmake-modules
, kbookmarks
, kcalutils
, kcmutils
, kcompletion
, kconfig
, kconfigwidgets
, kcoreaddons
, kdepim-addons
, kdepim-runtime
, kdepimTeam
, kdoctools
, kguiaddons
, ki18n
, kiconthemes
, kinit
, kio
, kldap
, kmail-account-wizard
, kmailtransport
, knotifications
, knotifyconfig
, kontactinterface
, kparts
, kpty
, kservice
, ktextwidgets
, ktnef
, kwallet
, kwidgetsaddons
, kwindowsystem
, kxmlgui
, libgravatar
, libkdepim
, libksieve
, libsecret
, mailcommon
, messagelib
, pim-sieve-editor
, qtkeychain
, qtscript
, qtwebengine
}:

mkDerivation {
  pname = "kmail";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi-search
    kbookmarks
    kcalutils
    kcmutils
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kdepim-addons
    kguiaddons
    ki18n
    kiconthemes
    kinit
    kio
    kldap
    kmail-account-wizard
    kmailtransport
    knotifications
    knotifyconfig
    kontactinterface
    kparts
    kpty
    kservice
    ktextwidgets
    ktnef
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    libgravatar
    libkdepim
    libksieve
    libsecret
    mailcommon
    messagelib
    pim-sieve-editor
    qtkeychain
    qtscript
    qtwebengine
  ];
  propagatedUserEnvPkgs = [ kdepim-runtime kwallet akonadi ];
}
