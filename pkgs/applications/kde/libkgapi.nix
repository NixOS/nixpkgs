{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  qtwebengine, kio, kcalendarcore, kcontacts,
  cyrus_sasl
}:

mkDerivation {
  name = "libkgapi";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ qtwebengine kio kcalendarcore kcontacts cyrus_sasl ];
}
