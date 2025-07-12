{
  mkDerivation,
  lib,
  akonadi,
  akonadi-import-wizard,
  akonadi-search,
  extra-cmake-modules,
  kaddressbook,
  kbookmarks,
  kcalutils,
  kcmutils,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kdepim-addons,
  kdepim-runtime,
  kdepimTeam,
  kdoctools,
  kguiaddons,
  ki18n,
  kiconthemes,
  kinit,
  kio,
  kldap,
  kleopatra,
  kmail-account-wizard,
  kmailtransport,
  knotifications,
  knotifyconfig,
  kontactinterface,
  kparts,
  kpty,
  kservice,
  ktextwidgets,
  ktnef,
  kuserfeedback,
  kwallet,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  libgravatar,
  libkdepim,
  libksieve,
  libsecret,
  mailcommon,
  messagelib,
  pim-data-exporter,
  pim-sieve-editor,
  qtkeychain,
  qtscript,
  qtwebengine,
}:

mkDerivation {
  pname = "kmail";
  meta = {
    homepage = "https://apps.kde.org/kmail2/";
    description = "Mail client";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
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
    kuserfeedback
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
    akonadi-import-wizard
    kaddressbook
    kleopatra
    pim-data-exporter
  ];
  outputs = [
    "out"
    "doc"
  ];
  propagatedUserEnvPkgs = [
    kdepim-runtime
    kwallet
    akonadi
  ];
  postFixup = ''
    wrapProgram "$out/bin/kmail" \
      --prefix PATH : "${
        lib.makeBinPath [
          akonadi
          akonadi-import-wizard
          kaddressbook
          kleopatra
          kmail-account-wizard
          pim-data-exporter
        ]
      }"
  '';
}
