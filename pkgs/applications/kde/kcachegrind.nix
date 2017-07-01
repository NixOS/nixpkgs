{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kio, ki18n, karchive, qttools,
  perl, python, php
}:

mkDerivation {
  name = "kcachegrind";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ orivej ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kio ];
  buildInputs = [ perl python php ki18n karchive qttools ];
}
