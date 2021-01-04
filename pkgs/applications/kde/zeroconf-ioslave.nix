{ mkDerivation, lib, extra-cmake-modules, kdoctools, kio, kdnssd }:

mkDerivation {
  name = "zeroconf-ioslave";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/zeroconf_ioslave";
    description = "Adds an entry to Dolphin's Network page to show local services";
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
    kdnssd
  ];
}
