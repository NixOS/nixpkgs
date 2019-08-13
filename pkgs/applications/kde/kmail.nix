{
  mkDerivation, lib, kdepimTeam, fetchpatch,
  extra-cmake-modules, kdoctools,
  akonadi-search, kbookmarks, kcalutils, kcmutils, kcompletion, kconfig,
  kconfigwidgets, kcoreaddons, kdelibs4support, kdepim-apps-libs, libkdepim,
  kdepim-runtime, kguiaddons, ki18n, kiconthemes, kinit, kio, kldap,
  kmail-account-wizard, kmailtransport, knotifications, knotifyconfig,
  kontactinterface, kparts, kpty, kservice, ktextwidgets, ktnef, kwallet,
  kwidgetsaddons, kwindowsystem, kxmlgui, libgravatar, libksieve, mailcommon,
  messagelib, pim-sieve-editor, qtscript, qtwebengine,
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
  ];
  propagatedUserEnvPkgs = [ kdepim-runtime kwallet ];
  patches = [
    ./kmail.patch

    # This patch should be backported in 19.04.4 KDE applications
    (fetchpatch {
      url = "https://cgit.kde.org/kmail.git/patch/?id=28a8cf907b3cd903aef0b963314df219afc6b66a";
      sha256 = "1gr94zmxnyhhyqjhcmm8aykvmf15pmn751cvdh4ll59rzbra8h0n";
    })
  ];
}
