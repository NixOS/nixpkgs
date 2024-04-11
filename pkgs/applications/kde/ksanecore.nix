{
  mkDerivation, lib,
  extra-cmake-modules, qtbase,
  ki18n, sane-backends
}:

mkDerivation {
  pname = "ksanecore";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ki18n sane-backends ];
  meta = with lib; {
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ andrevmatos ];
  };
}
