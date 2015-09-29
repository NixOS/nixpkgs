{ kdeApp
, lib
, automoc4
, cmake
, perl
, pkgconfig
, kdelibs
, libkipi
, libXfixes
}:

kdeApp {
  name = "ksnapshot";
  nativeBuildInputs = [
    automoc4
    cmake
    perl
    pkgconfig
  ];
  buildInputs = [
    kdelibs
    libkipi
    libXfixes
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
