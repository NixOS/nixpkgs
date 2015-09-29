{ kdeApp
, lib
, automoc4
, cmake
, perl
, pkgconfig
, libraw
, kdelibs
}:

kdeApp {
  name = "libkdcraw";
  nativeBuildInputs = [
    automoc4
    cmake
    perl
    pkgconfig
  ];
  buildInputs = [
    kdelibs
    libraw
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
