{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  exiv2, lcms2,
  baloo, kactivities, kdelibs4support, kio, kipi-plugins, libkdcraw, libkipi,
  phonon, qtimageformats, qtsvg, qtx11extras, kinit, fetchpatch
}:

mkDerivation {
  name = "gwenview";
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    baloo exiv2 kactivities kdelibs4support kio libkdcraw lcms2 libkipi phonon
    qtimageformats qtsvg qtx11extras
  ];
  propagatedUserEnvPkgs = [ kipi-plugins libkipi (lib.getBin kinit) ];

  # Fixes build with exiv2-0.27.1. Drop in 19.04.2
  patches = [
    (fetchpatch {
      url = "https://github.com/KDE/gwenview/commit/172560b845460b6121154f88221c855542219943.patch";
      sha256 = "0y1l34h2s7rhfknvg6ggcc389jfzhpq69wf0s3xd5ccwfw7c0ycq";
    })
  ];
}
