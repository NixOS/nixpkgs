{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  akonadi,
  calendarsupport,
}:

mkDerivation {
  pname = "akonadi-calendar-tools";
  meta = with lib; {
    homepage = "https://github.com/KDE/akonadi-calendar-tools";
    description = "Console applications and utilities for managing calendars in Akonadi";
    license = with licenses; [
      gpl2Plus
      cc0
    ];
    maintainers = with maintainers; [ kennyballou ];
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    akonadi
    calendarsupport
  ];
  outputs = [
    "out"
    "dev"
  ];
}
