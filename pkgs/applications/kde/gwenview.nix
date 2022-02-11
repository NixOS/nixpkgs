{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  exiv2, lcms2,
  baloo, kactivities, kio, kipi-plugins, kitemmodels, kparts, libkdcraw, libkipi,
  phonon, qtimageformats, qtsvg, qtx11extras, kinit
}:

mkDerivation {
  pname = "gwenview";
  meta = {
    homepage = "https://apps.kde.org/gwenview/";
    description = "KDE image viewer";
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    baloo kactivities kio kitemmodels kparts libkdcraw libkipi phonon
    exiv2 lcms2
    qtimageformats qtsvg qtx11extras
  ];
  propagatedUserEnvPkgs = [ kipi-plugins libkipi (lib.getBin kinit) ];
}
