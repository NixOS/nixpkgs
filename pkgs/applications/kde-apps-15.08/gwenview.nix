{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, baloo
, exiv2
, kactivities
, kdelibs4support
, kio
, lcms2
, phonon
, qtsvg
, qtx11extras
}:

kdeApp {
  name = "gwenview";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    exiv2
    kactivities
    kdelibs4support
    kio
    lcms2
    phonon
    qtsvg
  ];
  propagatedBuildInputs = [
    baloo
    qtx11extras
  ];
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
