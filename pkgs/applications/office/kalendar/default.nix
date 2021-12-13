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
, akonadi-contacts
, akonadi-calendar-tools
, kdepim-runtime
}:

mkDerivation rec {
  pname = "kalendar";
  version = "0.3.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "pim";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-foG8j/MRbDZyzM9KmxEARfWUQXMz8ylQgersE1/gtnQ=";
  };

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

    akonadi-contacts
    akonadi-calendar-tools
  ];

  propagatedUserEnvPkgs = [ akonadi kdepim-runtime ];

  meta = with lib; {
    description = "A calendar application using Akonadi to sync with external services (Nextcloud, GMail, ...)";
    homepage = "https://invent.kde.org/pim/kalendar/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
