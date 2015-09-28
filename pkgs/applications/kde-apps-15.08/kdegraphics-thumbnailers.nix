{ mkDerivation
, lib
, automoc4
, cmake
, perl
, pkgconfig
, kdelibs
, libkexiv2
, libkdcraw
}:

mkDerivation {
  name = "kdegraphics-thumbnailers";
  nativeBuildInputs = [
    automoc4
    cmake
    perl
    pkgconfig
  ];
  buildInputs = [
    kdelibs
    libkexiv2
    libkdcraw
  ];
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
