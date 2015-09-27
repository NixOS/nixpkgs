{ mkDerivation
, lib
, automoc4
, cmake
, perl
, pkgconfig
, boost
, gpgme
, kdelibs
, kdepimlibs
}:

mkDerivation {
  name = "kgpg";
  nativeBuildInputs = [
    automoc4
    cmake
    perl
    pkgconfig
  ];
  buildInputs = [
    boost
    gpgme
    kdelibs
    kdepimlibs
  ];
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
