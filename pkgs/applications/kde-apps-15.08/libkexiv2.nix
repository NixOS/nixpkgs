{ mkDerivation
, lib
, automoc4
, cmake
, perl
, pkgconfig
, exiv2
, kdelibs
}:

mkDerivation {
  name = "libkexiv2";
  nativeBuildInputs = [
    automoc4
    cmake
    perl
    pkgconfig
  ];
  buildInputs = [
    exiv2
    kdelibs
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
