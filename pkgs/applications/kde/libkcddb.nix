{
  mkDerivation,
  lib,
  extra-cmake-modules,
  qtbase,
  kdoctools,
  kcodecs,
  ki18n,
  kio,
  kwidgetsaddons,
  kcmutils,
  libmusicbrainz5,
}:

mkDerivation {
  pname = "libkcddb";
  meta = {
    license = with lib.licenses; [
      gpl2
      lgpl21
      bsd3
    ];
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    qtbase
    kcmutils
  ];
  propagatedBuildInputs = [
    kcodecs
    ki18n
    kio
    kwidgetsaddons
    libmusicbrainz5
  ];
}
