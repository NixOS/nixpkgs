{ mkDerivation, lib, extra-cmake-modules, kdoctools, kxmlgui, kbookmarks, kio, kactivities-stats }:

mkDerivation {
  name = "sweeper";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/sweeper";
    description = "Helps to clean unwanted traces the user leaves on the system";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kactivities-stats
    kbookmarks
    kio
    kxmlgui
  ];
}
