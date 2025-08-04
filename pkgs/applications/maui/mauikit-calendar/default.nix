{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  mauikit,
  qtquickcontrols2,
  akonadi,
  akonadi-contacts,
  akonadi-calendar,
  calendarsupport,
  eventviews,
}:

mkDerivation {
  pname = "mauikit-calendar";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    akonadi
    akonadi-contacts
    akonadi-calendar
    calendarsupport
    eventviews
    mauikit
    qtquickcontrols2
  ];

  meta = {
    homepage = "https://invent.kde.org/maui/mauikit-calendar";
    description = "Calendar support components for Maui applications";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ onny ];
  };
}
