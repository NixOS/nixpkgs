{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  baloo, exiv2, kactivities, kdelibs4support, kio, kipi-plugins, lcms2,
  libkdcraw, libkipi, phonon, qtimageformats, qtsvg, qtx11extras
}:

mkDerivation {
  name = "gwenview";
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [
    baloo kactivities kdelibs4support kio exiv2 lcms2 libkdcraw
    libkipi phonon qtimageformats qtsvg qtx11extras
  ];
  propagatedUserEnvPkgs = [ kipi-plugins ];
}
