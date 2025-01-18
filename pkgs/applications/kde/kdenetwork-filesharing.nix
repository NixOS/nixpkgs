{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kcoreaddons,
  kdeclarative,
  ki18n,
  kio,
  kwidgetsaddons,
  samba,
  qcoro,
}:

mkDerivation {
  pname = "kdenetwork-filesharing";
  meta = with lib; {
    license = [
      licenses.gpl2
      licenses.lgpl21
    ];
    maintainers = [ maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcoreaddons
    kdeclarative
    ki18n
    kio
    kwidgetsaddons
    samba
    qcoro
  ];
}
