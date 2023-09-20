{ mkDerivation, lib, extra-cmake-modules, qtbase, kdoctools
, kcodecs, ki18n, kio, kwidgetsaddons, kcmutils
, libmusicbrainz5 }:

mkDerivation {
  pname = "libkcddb";
  meta = with lib; {
    license = with licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = with maintainers; [ peterhoeg ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ qtbase kcmutils ];
  propagatedBuildInputs = [
    kcodecs ki18n kio kwidgetsaddons
    libmusicbrainz5
  ];
}
