{
  mkDerivation,
  lib,
  extra-cmake-modules,
  qtbase,
  ki18n,
  sane-backends,
}:

mkDerivation {
  pname = "ksanecore";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtbase
    ki18n
    sane-backends
  ];
  meta = {
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ andrevmatos ];
  };
}
