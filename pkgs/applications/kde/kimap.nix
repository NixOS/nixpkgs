{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  cyrus_sasl, kcoreaddons, ki18n, kio, kmime
}:

mkDerivation {
  name = "kimap";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ ki18n kio ];
  propagatedBuildInputs = [ cyrus_sasl kcoreaddons kmime ];
  outputs = [ "out" "dev" ];
}
