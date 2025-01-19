{
  mkDerivation,
  lib,
  extra-cmake-modules,
  qtquickcontrols2,
  networkmanager-qt,
  ki18n,
}:

mkDerivation {
  pname = "kpublictransport";
  meta = {
    license = [ lib.licenses.cc0 ];
    maintainers = [ ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    qtquickcontrols2
    networkmanager-qt
    ki18n
  ];
}
