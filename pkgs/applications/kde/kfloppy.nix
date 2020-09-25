{ mkDerivation, lib, extra-cmake-modules, kdoctools, kcompletion, kxmlgui }:

mkDerivation {
  name = "kfloppy";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/utilities/org.kde.kfloppy";
    description = "KFloppy is a utility to format 3.5\" and 5.25\" floppy disks";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kcompletion
    kxmlgui
  ];
}
