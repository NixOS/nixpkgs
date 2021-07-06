{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  karchive, ki18n, kio, perl, python3, php, qttools,
  kdbusaddons
}:

mkDerivation {
  pname = "kcachegrind";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ orivej ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ karchive ki18n kio perl python3 php qttools kdbusaddons ];
}
