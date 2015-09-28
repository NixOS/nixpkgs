{ mkDerivation
, lib
, automoc4
, cmake
, perl
, pkgconfig
, kdelibs
}:

mkDerivation {
  name = "libkipi";
  nativeBuildInputs = [
    automoc4
    cmake
    perl
    pkgconfig
  ];
  buildInputs = [
    kdelibs
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
