{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, makeWrapper

, qtbase
, qtquickcontrols2
, qtsvg
, qtlocation
, qtdeclarative
, qqc2-desktop-style

, kirigami2
, kdbusaddons
, ki18n
, kcalendarcore
, kconfigwidgets
, kwindowsystem
, kcoreaddons
, kcontacts
, kitemmodels
, kxmlgui
, knotifications
, kiconthemes
, kservice
, kmime
, kpackage
, eventviews
, calendarsupport

, akonadi
, akonadi-search
, akonadi-contacts
, akonadi-calendar-tools
, kdepim-runtime
, gpgme
, pimcommon
, mailcommon
, messagelib
}:

mkDerivation rec {
  pname = "kalendar";

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

  propagatedUserEnvPkgs = [ akonadi kdepim-runtime akonadi-search ];
  postFixup = ''
    wrapProgram "$out/bin/kalendar" \
      --prefix PATH : "${lib.makeBinPath [ akonadi kdepim-runtime akonadi-search ]}"
  '';

  meta = with lib; {
    description = "A calendar application using Akonadi to sync with external services (Nextcloud, GMail, ...)";
    homepage = "https://apps.kde.org/kalendar/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
