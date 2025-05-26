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
  meta = {
    homepage = "https://github.com/KDE/akonadi-calendar-tools";
    description = "Console applications and utilities for managing calendars in Akonadi";
    license = with lib.licenses; [
      gpl2Plus
      cc0
    ];
    maintainers = with lib.maintainers; [ kennyballou ];
    platforms = lib.platforms.linux;
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
