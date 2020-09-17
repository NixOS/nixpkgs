{ mkDerivation, lib, extra-cmake-modules, cdparanoia, kdoctools, kio, kcmutils, libkcddb, flac, libogg, libvorbis, libkcompactdisc }:

mkDerivation {
  name = "audiocd-kio";
  meta = with lib; {
    homepage = "https://userbase.kde.org/Kio-audiocd";
    description = "KIO slave to read audio CD";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  outputs = [ "out" "dev" ];
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    cdparanoia
    kcmutils
    kdoctools
    kio
    flac
    libkcddb
    libogg
    libvorbis
    libkcompactdisc
  ];
}
