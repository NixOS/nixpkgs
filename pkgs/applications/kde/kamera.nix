{ mkDerivation, lib, extra-cmake-modules, kdoctools, kconfig, kio, kxmlgui, libgphoto2 }:

mkDerivation {
  name = "kamera";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kamera";
    description = "Picture Transfer Protocol (PTP) is an older method of talking to camera devices";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kconfig
    kdoctools
    kio
    kxmlgui
    libgphoto2
  ];
}
