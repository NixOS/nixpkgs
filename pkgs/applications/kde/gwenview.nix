{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  exiv2, lcms2,
  baloo, kactivities, kdelibs4support, kio, kipi-plugins, libkdcraw, libkipi,
  phonon, qtimageformats, qtsvg, qtx11extras
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
  propagatedUserEnvPkgs = [ kipi-plugins ];
}
