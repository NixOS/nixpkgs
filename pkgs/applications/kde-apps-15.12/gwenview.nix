{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
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
    makeQtWrapper
  ];
  buildInputs = [
    exiv2
    lcms2
    phonon
    qtsvg
  ];
  propagatedBuildInputs = [
    baloo
    kactivities
    kdelibs4support
    kio
    qtx11extras
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/gwenview"
  '';
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
