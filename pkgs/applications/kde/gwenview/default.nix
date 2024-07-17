{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  exiv2,
  lcms2,
  cfitsio,
  baloo,
  kactivities,
  kio,
  kipi-plugins,
  kitemmodels,
  kparts,
  libkdcraw,
  libkipi,
  phonon,
  qtimageformats,
  qtsvg,
  qtx11extras,
  kinit,
  kpurpose,
  kcolorpicker,
  kimageannotator,
  wayland,
  wayland-protocols,
}:

mkDerivation {
  pname = "gwenview";
  meta = {
    homepage = "https://apps.kde.org/gwenview/";
    description = "KDE image viewer";
    license = with lib.licenses; [
      gpl2Plus
      fdl12Plus
    ];
    maintainers = [ lib.maintainers.ttuegel ];
    mainProgram = "gwenview";
  };

  # Fix build with versioned kImageAnnotator
  patches = [ ./kimageannotator.patch ];

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    baloo
    kactivities
    kio
    kitemmodels
    kparts
    libkdcraw
    libkipi
    phonon
    exiv2
    lcms2
    cfitsio
    qtimageformats
    qtsvg
    qtx11extras
    kpurpose
    kcolorpicker
    kimageannotator
    wayland
    wayland-protocols
  ];
  propagatedUserEnvPkgs = [
    kipi-plugins
    libkipi
    (lib.getBin kinit)
  ];
}
