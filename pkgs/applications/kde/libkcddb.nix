{ mkDerivation, lib, extra-cmake-modules, qtbase, kdoctools
, kcodecs, ki18n, kio, kwidgetsaddons
, libmusicbrainz5 }:

mkDerivation {
  name = "libkcddb";
  meta = with lib; {
    license = with licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = with maintainers; [ peterhoeg ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase kdoctools ];
  propagatedBuildInputs = [
    kcodecs ki18n kio kwidgetsaddons
    libmusicbrainz5
  ];
}
