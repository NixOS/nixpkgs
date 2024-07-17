{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  makeWrapper,

  qtbase,
  qtquickcontrols2,
  qtsvg,
  qtlocation,
  qtdeclarative,
  qqc2-desktop-style,

  kirigami2,
  kirigami-addons,
  kdbusaddons,
  ki18n,
  kcalendarcore,
  kconfigwidgets,
  kwindowsystem,
  kcoreaddons,
  kcontacts,
  kitemmodels,
  kxmlgui,
  knotifications,
  kiconthemes,
  kservice,
  kmime,
  kpackage,
  eventviews,
  calendarsupport,

  akonadi,
  akonadi-search,
  akonadi-contacts,
  akonadi-calendar-tools,
  kdepim-runtime,
  gpgme,
  pimcommon,
  mailcommon,
  messagelib,
}:

mkDerivation {
  pname = "merkuro";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    makeWrapper
  ];

  buildInputs = [
    qtbase
    qtquickcontrols2
    qtsvg
    qtlocation
    qtdeclarative
    qqc2-desktop-style

    kirigami2
    kirigami-addons
    kdbusaddons
    ki18n
    kcalendarcore
    kconfigwidgets
    kwindowsystem
    kcoreaddons
    kcontacts
    kitemmodels
    kxmlgui
    knotifications
    kiconthemes
    kservice
    kmime
    kpackage
    eventviews
    calendarsupport

    akonadi-search
    akonadi-contacts
    akonadi-calendar-tools
    kdepim-runtime

    gpgme
    pimcommon
    mailcommon
    messagelib
  ];

  propagatedUserEnvPkgs = [
    akonadi
    kdepim-runtime
    akonadi-search
  ];
  qtWrapperArgs = [
    ''--prefix PATH : "${
      lib.makeBinPath [
        akonadi
        kdepim-runtime
        akonadi-search
      ]
    }"''
  ];

  meta = with lib; {
    description = "A calendar application using Akonadi to sync with external services (Nextcloud, GMail, ...)";
    homepage = "https://invent.kde.org/pim/merkuro";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Thra11 ];
    platforms = platforms.linux;
  };
}
