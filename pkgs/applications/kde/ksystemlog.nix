{
  mkDerivation, lib,
  extra-cmake-modules, gettext, kdoctools,
  karchive, kconfig, kio
}:

mkDerivation {
  pname = "ksystemlog";

  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools ];
  propagatedBuildInputs = [ karchive kconfig kio ];

  meta = with lib; {
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ peterhoeg ];
  };
}
