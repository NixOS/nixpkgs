{ mkDerivation, lib, extra-cmake-modules, kdoctools, kio, knotifications, shared-mime-info }:

mkDerivation {
  name = "kbackup";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kbackup";
    description = "Application which lets you back up your data";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    shared-mime-info
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kio
    knotifications
  ];
}
