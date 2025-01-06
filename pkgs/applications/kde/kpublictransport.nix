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

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    qtquickcontrols2
    networkmanager-qt
    ki18n
  ];

  meta = {
    license = [ lib.licenses.cc0 ];
    maintainers = [ ];
  };
}
