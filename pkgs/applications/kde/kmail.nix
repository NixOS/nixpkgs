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
# external applications needing to be called are specified in an external file,
# such that they can be re-used by `kontact`
, pimExternalApplications
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
  ]
  ++ pimExternalApplications.kmailApplications;
  outputs = [ "out" "doc" ];
  propagatedUserEnvPkgs = [ kdepim-runtime kwallet akonadi ];
  postFixup = ''
    wrapProgram "$out/bin/kmail" \
      --prefix PATH : "${lib.makeBinPath pimExternalApplications.kmailApplications}"
  '';
}
