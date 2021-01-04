{ mkDerivation, lib, extra-cmake-modules, kdoctools, akonadi, calendarsupport }:

mkDerivation {
  name = "akonadi-calendar-tools";
  meta = with lib; {
    homepage = "https://github.com/KDE/akonadi-calendar-tools";
    description = "Console applications and utilities for managing calendars in Akonadi";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    akonadi
    calendarsupport
  ];
}
