{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  baloo, exiv2, kactivities, kdelibs4support, kio, kipi-plugins, lcms2,
  libkdcraw, libkipi, phonon, qtimageformats, qtsvg, qtx11extras
}:

let
  unwrapped =
    kdeApp {
      name = "gwenview";
      meta = {
        license = with lib.licenses; [ gpl2 fdl12 ];
        maintainers = [ lib.maintainers.ttuegel ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        baloo kactivities kdelibs4support kio exiv2 lcms2 libkdcraw
        libkipi phonon qtimageformats qtsvg qtx11extras
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/gwenview" ];
  paths = [ kipi-plugins ];
}
