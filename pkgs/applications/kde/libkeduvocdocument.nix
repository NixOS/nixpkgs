{ mkDerivation, lib, extra-cmake-modules, kdoctools, kio }:

mkDerivation {
  name = "libkeduvocdocument";
  meta = with lib; {
    homepage = "https://kde.org";
    description = "Library for reading/writing KVTML";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kio
  ];
}
